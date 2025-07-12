module TopModule #(
    parameter WIDTH = 16,
    parameter UPPER_BYTE_WIDTH = 8,
    parameter LOWER_BYTE_WIDTH = 8
)(
    input  [WIDTH-1:0] in,
    output [UPPER_BYTE_WIDTH-1:0] out_hi,
    output [LOWER_BYTE_WIDTH-1:0] out_lo
);

    assign out_hi = in >> UPPER_BYTE_WIDTH;
    assign out_lo = in & {(LOWER_BYTE_WIDTH){1'b1}};

endmodule