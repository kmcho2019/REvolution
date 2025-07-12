module TopModule(
    input  wire [3:0] in,
    input  wire       enable,  // New enable signal
    output wire       out_and,
    output wire       out_or,
    output wire       out_xor
);

    // Original logic operations
    wire and_result = &in;
    wire or_result  = |in;
    wire xor_result = ^in;

    // Gated outputs
    assign out_and = enable ? and_result : 1'b0;
    assign out_or  = enable ? or_result  : 1'b0;
    assign out_xor = enable ? xor_result : 1'b0;

endmodule