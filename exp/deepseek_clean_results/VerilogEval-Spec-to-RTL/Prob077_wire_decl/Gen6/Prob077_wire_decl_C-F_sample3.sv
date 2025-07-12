module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out,
    output out_n
);

    // First layer: AND operations
    wire ab_and = a & b;  // AND of a and b
    wire cd_and = c & d;  // AND of c and d

    // Second layer: OR operation and complement
    assign out = ab_and | cd_and;  // OR of both AND outputs
    assign out_n = ~out;           // Complement of final output

endmodule