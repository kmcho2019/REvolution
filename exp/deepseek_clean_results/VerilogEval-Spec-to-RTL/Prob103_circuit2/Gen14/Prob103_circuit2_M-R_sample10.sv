module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    // Implement XNOR using its AND-OR equivalent form
    // q = (a·b·c·d) + (~a·~b·c·d) + (~a·b·~c·d) + (~a·b·c·~d) + 
    //      (a·~b·~c·d) + (a·~b·c·~d) + (a·b·~c·~d) + (~a·~b·~c·~d)
    wire term1 = a & b & c & d;
    wire term2 = ~a & ~b & c & d;
    wire term3 = ~a & b & ~c & d;
    wire term4 = ~a & b & c & ~d;
    wire term5 = a & ~b & ~c & d;
    wire term6 = a & ~b & c & ~d;
    wire term7 = a & b & ~c & ~d;
    wire term8 = ~a & ~b & ~c & ~d;
    
    assign q = term1 | term2 | term3 | term4 | term5 | term6 | term7 | term8;

endmodule