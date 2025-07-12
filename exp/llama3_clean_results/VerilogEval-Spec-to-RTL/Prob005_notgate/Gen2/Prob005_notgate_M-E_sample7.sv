module TopModule(
    input in,
    output out
);
    wire not_in;
    assign not_in = ~in;
    assign out = (in == 0) ? 1 : 0;
endmodule