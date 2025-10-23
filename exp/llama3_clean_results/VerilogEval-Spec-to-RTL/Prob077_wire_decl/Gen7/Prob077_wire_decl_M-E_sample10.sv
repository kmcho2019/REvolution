module ConfigurableLogic(
    input  a,
    input  b,
    input  c,
    input  d,
    output out,
    output out_n
);
    wire and_out1, and_out2;

    // Perform AND operations
    assign and_out1 = a & b;
    assign and_out2 = c & d;

    // Perform OR operation
    assign out = and_out1 | and_out2;

    // Perform NOT operation
    assign out_n = ~out;
endmodule