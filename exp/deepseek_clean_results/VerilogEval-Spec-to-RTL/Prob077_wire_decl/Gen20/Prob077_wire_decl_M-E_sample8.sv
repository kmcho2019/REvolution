module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out,
    output out_n
);
    wire w1, w2;  // Intermediate wires
    
    // First layer: AND operations
    assign w1 = a & b;
    assign w2 = c & d;
    
    // Second layer: OR operation and output
    assign out = w1 | w2;
    
    // Inverted output
    assign out_n = ~out;
endmodule