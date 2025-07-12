module TopModule #(
    parameter INPUT_WIDTH = 16,
    parameter SPLIT_POINT = 8
) (
    input  [INPUT_WIDTH-1:0] in,
    output [SPLIT_POINT-1:0] out_hi,
    output [INPUT_WIDTH-SPLIT_POINT-1:0] out_lo
);

    assign out_hi = in[INPUT_WIDTH-1 : INPUT_WIDTH-SPLIT_POINT];
    assign out_lo = in[SPLIT_POINT-1 : 0];

endmodule