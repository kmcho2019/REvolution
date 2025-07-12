module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out,
    output out_n
);
    // First layer: AND operations
    wire ab_and = a & b;
    wire cd_and = c & d;
    
    // Second layer: OR operation
    assign out = ab_and | cd_and;
    
    // Inverted output
    assign out_n = ~out;
endmodule