module TopModule(
    input  in,
    output out
);

    wire not_in;
    assign not_in = ~in;

    assign out = not_in;

endmodule