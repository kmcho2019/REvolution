module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out,
    output out_n
);
    wire ab_and, cd_and;  // Intermediate wires for AND operations
    
    // First layer: AND operations
    assign ab_and = a & b;
    assign cd_and = c & d;
    
    // Second layer: OR operation and inversion
    assign out = ab_and | cd_and;
    assign out_n = ~out;
endmodule