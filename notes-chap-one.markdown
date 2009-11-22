Working through SCIP notes


Scheme is a dialect of Lisp, and the programming language came from the late 1950's! It's father is John McCarthy , and he outlined its behaviour in [Recursive Functions of Symbolic Expressions and Their Computation by Machine][1]

There is no canonical lisp, like there is for Python, or Ruby. Instead:

> Lisp's informal evolution has continued through the years, and the community of Lisp users has traditionally resisted attempts to promulgate any 'official' definition of the language. This evolution, together with the flexibility and elegance of the initial conception, has enabled Lisp, which is the second oldest language in widespread use today (only Fortran is older), to continually adapt to encompass the most modern ideas about program design. Thus, Lisp is by now a family of dialects, which, while sharing most of the original features, may differ from one another in significant ways. The dialect of Lisp used in this book is called Scheme

Why I'm doing this. To get a grounding to let me attack problems more efficiently.

> A programmer should acquire good algorithms and idioms. Even though some programs resist precise 
specifications, it is the responsibility of the programmer to estimate, and always to attempt to improve, 
their performance. 

Lisp and Pascal seem to be at odds with each other in the same way that strongly typed and weakly typed languages are:

> It is better to have 100 functions operate on one data structure than to have 10 functions 
operate on 10 data structures. As a result the pyramid must stand unchanged for a millennium; the 
organism must evolve or perish.

Interesting motivation for this:

> Thus, programs must be written for people to read, and only incidentally for machines to execute. Second, we believe that the essential material to be addressed by a subject at this level is not the syntax of particular programming-language constructs, nor clever algorithms for computing particular functions efficiently, nor even the mathematical analysis of algorithms and the foundations of computing, _but rather the techniques used to control the intellectual complexity of large software systems_.

The preface here is basically describing lisp as a way to communicate ideas, and visualise them, rather than how to make a machine do stuff. 

> procedural epistemology -- the study of the structure of knowledge from an imperative point 
of view, as opposed to the more declarative point of view taken by classical mathematical subjects.

I'm particularly interested in the approach to teaching the language, with the emphasis on not formally teaching students that 'this is a class, and this is an array etc.'. 


> In teaching our material we use a dialect of the programming language Lisp. We never formally teach the 
language, because we don't have to. We just use it, and students pick it up in a few days. This is one great 
advantage of Lisp-like languages: They have very few ways of forming compound expressions, and 
almost no syntactic structure.

How we describe things using programs, according to the lisp book:

* primitive expressions, which represent the simplest entities the language is concerned with 

* means of combination, by which compound elements are built from simpler ones, and 

* means of abstraction, by which compound elements can be named and manipulated as units. 

Right now, this is loosely corresponding to `variables`, `functions` and `objects`, when I see this through a javascript shaped lens.

#### Learning the syntax

Okay, lisp syntax is unlike any other languages I've used before. For example adding 400 to 300, is done like this:

    (+ 300 400)

This approach has two advantages though:

1) We can add any number of elements to this list, without needing to define the length like with normal notation

    (+ 21 35 12 7) 
    (* 25 4 12)

2) It also keeps expressions unambiguous:

    (+ (* 3 5) (- 10 6))

This is clearing adding the product of three multiplied by five (15), and 10 minus 6 (4) to give us 19.

##### Making it more readable:

The problem is, it leads us to ending up with expressions like this:

    (+ (* 3 (+ (* 2 4) (+ 3 5))) (+ (- 10 7) 6)) 

I don't know about you, but I struggle to read that. So what we can do instead is this:

    (+ (* 3 
          (+ (* 2 4) 
             (+ 3 5))) 
       (+ (- 10 7)
          6))

If you read from the prefix, this approach should make it clearer that we're taking the result here:

    (+ (* 2 4) 
       (+ 3 5)))

And multiplying it by 3, to get an answer of 48:

    (* 3 
          (+ (* 2 4) 
             (+ 3 5)))

To this result, we're adding the product of the second part, to give us a final result of 57 (48, plus 9):

    (+ (- 10 7)
       6))

##### Defining variables in lisp

We can give stuff a name using `define` with Lisp. This example shows us checking for proof of the area of a circle:

    (define pi 3.14159) 
    (define radius 10) 
    (* pi (* radius radius)) 
    314.159 
    (define area_of_cirle (* pi (* radius radius)) ) 
    )


#### A result of this: tree accumulation

The upshot of this _prefix notation_, is that we can represent expressions as trees of sorts:


    (* (+ 2 (* 4 6)) 
       (+ 3 5 7))

![Fig1 1 Tree Accumulation](sicp_files/fig1-1-tree-accumulation.png)

The important point here is that meaning comes from the bottom up as you work toward the final result:

> The key point to notice is the role of the environment in determining the meaning of the symbols in expressions. In an interactive language such as Lisp, it is meaningless to speak of the value of an expression such as (+ x 1) without specifying any information about the environment that would provide a meaning for the symbol x (or even for the symbol +).

So far we've seen the prefix notation stuff, but without realising it we've been using our first _special form_ here when we've used `define`. Remember when we were talking about prefix notation, and how you can add an arbitrary number of elements to sum up, like this?

       (+ 3 5 7))

Define is called a special form because it you need to pass in data according to a certain pattern. Here's a simple usage of `define`:

    (define lazypi 3.14)

Now here's a slightly more involved version, with parameters you can pass in:

    (define (square x) (* x x)) 

This is basically saying "To square x, multiply x by x". Or if we used parens in english it would look like this:

    (to (square x), (multiply x by x))

The syntax for using `define` is like so:

    (define (<name> <formal parameters>) <body>)

Doing this lets us layer up functionality like this:

    (define (sum-of-squares x y) 
      (+ (square x) (square y))) 
    (sum-of-squares 3 4) 

Then add more like this:

    (define (f a) 
      (sum-of-squares (+ a 1) (* a 2)))

If we pass in (f 5), we'll have a return value of 136. Note here that at each section our newly defined `sum-of-squares` or `square` functions work just like the basic `+` or `-` syntax. We have here a _compound procedure_.

It's helpful to think of what's happening here as series of substitutions of culminating in our number of 136 like this:

    (f _5_) # we pass in 5 as our parameter
    (sum-of-squares (+ _5_ 1) (* _5_ 2))) we then resolve 5 plus 1, and 5 times 2
    (+ (square 6) (square 10)))  # next we square them
    (+ 36 100) # and finally add the products together
    136 # to arrive at our desired figure

This is called the _substitution model_. It's important to understand that we just did hear was a calculation using _applicative order_, as opposed to _normal order_. The difference between the two is that applicative order works by evaluating each part of the tree first, then moving to the next stage, whereas normal order works the other way, by holding off evaluation until the final stage. 

So to be clear:

Normal order -  every procedure is expanded fully, before it starts being reduced back to a final figure.
Applicative order - procedures are evaluated along the way before their value is passed along to the next procedure.

#### Handling conditionals, the lisp way:

So far, we haven't been covered any kind of conditionals in lisp. You tend to need them in programming, and they look like this in lisp:

    (define (abs x) 
      (
        cond ((> x 0) x) 
             ((= x 0) 0) 
             ((< x 0) (- x))
      )
    )

So, they're somewhat like a cross between a `if..then` statement, and a `case..when` statement. Each condition is evaluated here in order; if x is greater than 0, then x is returned. And the condition loop stops. If x is - then is returned, and finally is both have proven false, and x is negative, then the negative operator is applied, to return the positive number back.

We can save a few characters like this:

    (define (abs x) 
      (cond ((< x 0) (- x)) 
            (else x))) 

Or like this, using an lisp's if statement:

    (define (abs x) 
      (if (< x 0) 
          (- x) 
          x)) 

We can think of this behaving in a more generalised form like so: 

    (if <predicate> <consequent> <alternative>)

Note how we don't need the else here; we just add the alternative value at the end

There a few other _composition operations_ too; `and`, `or` and `not`. They work like logical `and`, `or` and `not` normally do:

This returns true for values,6,7,8,9, because both (> x 5) and (x < 10) evaluate as true:
 
    (and (> x 5) (< x 10)) 

We can use `or` here to make a equal or greater procedure. If `x` is greater than or equal to `y` then this returns true:

    (define (>= x y) 
      (or (> x y) (= x y))) 

The other way we can write `>=` would be to use `not`. We're checking is

    (define (>= x y) 
      (not (< x y)))




[1]: put_it_google



