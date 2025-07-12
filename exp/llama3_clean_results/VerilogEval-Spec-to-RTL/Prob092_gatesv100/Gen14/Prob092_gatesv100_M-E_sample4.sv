module TopModule(
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    wire [99:0] and_result;
    wire [99:0] or_result;
    wire [99:0] xor_result;

    // Compute AND result for out_both vector
    assign and_result[99] = 1'b0;
    for (genvar i = 0; i < 99; i++) begin
        assign and_result[i] = in[i] & in[i+1];
    end

    // Compute OR result for out_any vector
    assign or_result[0] = 1'b0;
    for (genvar i = 1; i < 100; i++) begin
        assign or_result[i] = in[i] | in[i-1];
    end

    // Compute XOR result for out_different vector with wrap-around
    for (genvar i = 0; i < 100; i++) begin
        assign xor_result[i] = in[i] ^ in[(i+1) % 100];
    end

    // Assign output vectors
    assign out_both = and_result;
    assign out_any = or_result;
    assign out_different = xor_result;

endmodule