module TopModule(
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // Initialize out_both with zeros
    assign out_both[99] = 1'b0;
    // For each bit in the input vector (except the most significant bit)
    // out_both is 1 if the current bit and its neighbor to the left are both 1
    for (genvar i = 0; i < 99; i++) begin
        assign out_both[i] = in[i] & in[i + 1];
    end

    // Initialize out_any with zeros
    assign out_any[0] = 1'b0;
    // For each bit in the input vector (except the least significant bit)
    // out_any is 1 if the current bit or its neighbor to the right is 1
    for (genvar i = 1; i < 100; i++) begin
        assign out_any[i] = in[i] | in[i - 1];
    end

    // For each bit in the input vector
    // out_different is 1 if the current bit is different from its neighbor to the left
    // The vector is treated as wrapping around, so the least significant bit is compared with the most significant bit
    for (genvar i = 0; i < 100; i++) begin
        assign out_different[i] = in[i] ^ in[(i + 1) % 100];
    end

endmodule