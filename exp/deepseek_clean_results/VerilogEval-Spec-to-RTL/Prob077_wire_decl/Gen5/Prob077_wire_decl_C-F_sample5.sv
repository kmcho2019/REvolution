module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out,
    output out_n
);

    // First layer AND operations with named wires
    wire ab_and = a & b;
    wire cd_and = c & d;
    
    // Second layer OR and NOT operations
    assign out = ab_and | cd_and;
    assign out_n = ~out;

endmodule