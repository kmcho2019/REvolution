module TopModule(
    input [99:0] in,
    output reg out_and,
    output reg out_or,
    output reg out_xor
);

    reg [24:0] and_chunk;
    reg [24:0] or_chunk;
    reg [24:0] xor_chunk;

    // Divide the 100-bit input vector into 25 chunks of 4 bits each
    integer i;
    always @(in) begin
        for (i = 0; i < 25; i = i + 1) begin
            and_chunk[i] = &in[(i * 4) + 3 : i * 4];
            or_chunk[i] = |in[(i * 4) + 3 : i * 4];
            xor_chunk[i] = ^in[(i * 4) + 3 : i * 4];
        end

        // Combine the results from each chunk using the same logical operations
        out_and = 1'b1;
        out_or = 1'b0;
        out_xor = 1'b0;
        for (i = 0; i < 25; i = i + 1) begin
            out_and = out_and & and_chunk[i];
            out_or = out_or | or_chunk[i];
            out_xor = out_xor ^ xor_chunk[i];
        end
    end

endmodule