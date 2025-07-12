module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out,
    output out_n
);
    wire and_out1, and_out2;

    // Directly implement AND operations
    assign and_out1 = a & b;
    assign and_out2 = c & d;

    // Implement OR operation and assign output
    assign out = and_out1 | and_out2;

    // Assign out_n as the inverse of out
    assign out_n = ~out;
endmodule