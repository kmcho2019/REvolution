module BitSplitter #(
    parameter INPUT_WIDTH = 16,
    parameter SPLIT_POINT = 8
) (
    input  logic [INPUT_WIDTH-1:0] in,
    output logic [SPLIT_POINT-1:0] out_hi,
    output logic [INPUT_WIDTH-SPLIT_POINT-1:0] out_lo
);

    // Direct assignment for efficiency and simplicity
    assign out_hi = in[INPUT_WIDTH-1:INPUT_WIDTH-SPLIT_POINT];
    assign out_lo = in[SPLIT_POINT-1:0];

endmodule

module TopModule(
    input  logic [15:0] in,
    output logic [7:0] out_hi,
    output logic [7:0] out_lo
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