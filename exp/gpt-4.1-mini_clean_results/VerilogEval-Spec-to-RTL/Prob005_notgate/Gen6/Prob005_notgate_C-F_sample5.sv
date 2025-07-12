module TopModule (
    input  wire in,
    output wire out
);
    wire inverted;
    assign inverted = ~in;
    assign out = inverted;
endmodule