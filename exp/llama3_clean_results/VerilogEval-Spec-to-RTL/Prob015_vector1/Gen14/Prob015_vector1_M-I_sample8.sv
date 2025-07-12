module BitSplitter #(
    parameter INPUT_WIDTH = 16,
    parameter SPLIT_POINT = 8
) (
    input  [INPUT_WIDTH-1:0] in,
    output [SPLIT_POINT-1:0] out_hi,
    output [INPUT_WIDTH-SPLIT_POINT-1:0] out_lo
);

    // Direct assignment for efficiency and simplicity
    // Using synthesis directives to optimize for area and power
    (* synthesis keep, synthesis resource_sharing="off" *)
    assign out_hi = in[INPUT_WIDTH-1:INPUT_WIDTH-SPLIT_POINT];
    (* synthesis keep, synthesis resource_sharing="off" *)
    assign out_lo = in[SPLIT_POINT-1:0];

endmodule

module TopModule(
    input  [15:0] in,
    output [7:0] out_hi,
    output [7:0] out_lo
);

    // Instantiate BitSplitter with specified parameters
    BitSplitter #(
        .INPUT_WIDTH(16),
        .SPLIT_POINT(8)
    ) splitter(
        .in(in),
        .out_hi(out_hi),
        .out_lo(out_lo)
    );

endmodule