module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);
    // The Karnaugh map with inputs: ab as columns, cd as rows.
    // cd\ab  00 01 11 10
    // 00      1  1  0  1
    // 01      1  0  0  1
    // 11      0  1  1  1
    // 10      1  1  0  0

    // Assign input bits to variables for clarity
    wire ab0 = ~a & ~b;
    wire ab1 = ~a &  b;
    wire ab3 =  a &  b;
    wire ab2 =  a & ~b;

    wire cd0 = ~c & ~d;
    wire cd1 = ~c &  d;
    wire cd3 =  c &  d;
    wire cd2 =  c & ~d;

    // Sum the minterms where output = 1
    assign out =
           (cd0 & ab0)  // c=0,d=0,a=0,b=0 : minterm 0
        |  (cd0 & ab1)  // c=0,d=0,a=0,b=1 : minterm 1
        |  (cd0 & ab2)  // c=0,d=0,a=1,b=0 : minterm 2
        |  (cd1 & ab0)  // c=0,d=1,a=0,b=0 : minterm 4
        |  (cd1 & ab3)  // c=0,d=1,a=1,b=1 : minterm 7
        |  (cd2 & ab0)  // c=1,d=0,a=0,b=0 : minterm 8
        |  (cd2 & ab1)  // c=1,d=0,a=0,b=1 : minterm 9
        |  (cd3 & ab1)  // c=1,d=1,a=0,b=1 : minterm 13
        |  (cd3 & ab2)  // c=1,d=1,a=1,b=0 : minterm 14
        |  (cd3 & ab3); // c=1,d=1,a=1,b=1 : minterm 15

endmodule