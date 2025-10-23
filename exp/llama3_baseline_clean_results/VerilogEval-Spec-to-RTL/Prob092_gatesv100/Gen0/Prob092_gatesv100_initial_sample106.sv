module TopModule(
    input  [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // Iterate over each bit in the input vector
    genvar i;
    generate
        for (i = 0; i <= 99; i++) begin
            // out_both: Check if current bit and its left neighbor are both 1
            // For the most significant bit (in[99]), there's no left neighbor, so out_both[99] = 0
            if (i == 99) begin
                assign out_both[99] = 1'b0;
            end else begin
                assign out_both[i] = in[i] & in[i+1];
            end

            // out_any: Check if current bit or its right neighbor is 1
            // For the least significant bit (in[0]), there's no right neighbor, so out_any[0] = 0
            if (i == 0) begin
                assign out_any[0] = 1'b0;
            end else begin
                assign out_any[i] = in[i] | in[i-1];
            end

            // out_different: Check if current bit is different from its left neighbor
            // Treat the vector as circular, so in[99]'s left neighbor is in[0]
            if (i == 99) begin
                assign out_different[99] = in[99] ^ in[0];
            end else begin
                assign out_different[i] = in[i] ^ in[i+1];
            end
        end
    endgenerate

endmodule