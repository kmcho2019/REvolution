// Improved version maintaining flexibility and simplicity
module TopModule(
    input  [15:0] in,
    output [7:0] out_hi,
    output [7:0] out_lo
);

    // Direct assignment for simplicity and efficiency
    assign out_hi = in[15:8];
    assign out_lo = in[7:0];

endmodule

// The BitSplitter module remains as a flexible, parameterizable option
module BitSplitter #(
    parameter INPUT_WIDTH = 16,
    parameter SPLIT_POINT = 8
) (
    input  [INPUT_WIDTH-1:0] in,
    output [SPLIT_POINT-1:0] out_hi,
    output [INPUT_WIDTH-SPLIT_POINT-1:0] out_lo
);

    // Using direct assignments for simplicity and efficiency
    assign out_hi = in[INPUT_WIDTH-1 : INPUT_WIDTH-SPLIT_POINT];
    assign out_lo = in[SPLIT_POINT-1 : 0];

endmodule