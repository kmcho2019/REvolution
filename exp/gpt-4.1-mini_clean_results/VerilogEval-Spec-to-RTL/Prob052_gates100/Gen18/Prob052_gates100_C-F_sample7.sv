module TopModule (
    input  [99:0] in,
    output reg    out_and,
    output reg    out_or,
    output reg    out_xor
);
    // Local variables for hierarchical reduction stored as reg arrays inside always block
    // We'll perform iterative pairwise reduction until a single bit remains for each logic function.
    integer level_size, i;
    reg [99:0] and_level;
    reg [99:0] or_level;
    reg [99:0] xor_level;

    always @(*) begin
        // Initialize the first level with input bits
        for (i = 0; i < 100; i = i + 1) begin
            and_level[i] = in[i];
            or_level[i]  = in[i];
            xor_level[i] = in[i];
        end
        // Start reduction at size 100 inputs
        level_size = 100;
        // Perform balanced binary tree reduction until size == 1
        while (level_size > 1) begin
            for (i = 0; i < level_size / 2; i = i + 1) begin
                and_level[i] = and_level[2*i] & and_level[2*i + 1];
                or_level[i]  = or_level[2*i]  | or_level[2*i + 1];
                xor_level[i] = xor_level[2*i] ^ xor_level[2*i + 1];
            end
            if (level_size % 2) begin
                // Odd number of inputs: carry last element forward
                and_level[level_size / 2] = and_level[level_size - 1];
                or_level[level_size / 2]  = or_level[level_size - 1];
                xor_level[level_size / 2] = xor_level[level_size - 1];
                level_size = level_size / 2 + 1;
            end else begin
                level_size = level_size / 2;
            end
        end
        // Final output is the single remaining bit
        out_and = and_level[0];
        out_or  = or_level[0];
        out_xor = xor_level[0];
    end

endmodule