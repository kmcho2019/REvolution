module TopModule (
    input  wire in,
    output wire out
);
    wire not_in;
    assign not_in = ~in;
    assign out = not_in;
endmodule