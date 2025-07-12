module adder_pipe_64bit (
    input               clk,
    input               rst_n,
    input               i_en,
    input       [63:0]  adda,
    input       [63:0]  addb,
    output reg  [64:0]  result,
    output reg          o_en
);

    // 64 pipeline stages + 1 for carry out
    reg [63:0] adda_pipe [0:64];  // operands pipeline registers
    reg [63:0] addb_pipe [0:64];
    reg        carry_pipe [0:64];  // carry registers per stage
    reg        i_en_pipe [0:64];   // enable pipeline

    integer i;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // reset pipeline registers to zero
            for (i = 0; i <= 64; i = i + 1) begin
                adda_pipe[i] <= 64'b0;
                addb_pipe[i] <= 64'b0;
                carry_pipe[i] <= 1'b0;
                i_en_pipe[i] <= 1'b0;
            end
            result <= 65'b0;
            o_en <= 1'b0;
        end else begin
            // Stage 0 inputs come from module inputs
            adda_pipe[0] <= adda;
            addb_pipe[0] <= addb;
            carry_pipe[0] <= 1'b0;      // initial carry_in = 0
            i_en_pipe[0] <= i_en;

            // Propagate through pipeline stages
            for (i = 1; i <= 64; i = i + 1) begin
                // Propagate operands bits shifted by one stage, but only bitwise we care about one bit per stage
                // Actually, each stage processes one bit at position (i-1)
                // Register the operands bits for this stage from previous stage
                // But since we keep full 64-bit vectors in each pipeline stage, we just shift the bits by 1 pipeline stage,
                // and only bit (i-1) is used in stage i.

                // Pass previous operands unchanged (the full 64-bit vector for next stage),
                // but it's only needed to register the inputs at stage 0.
                // For stages > 0, operands register only moves forward the same vector.
                adda_pipe[i] <= adda_pipe[i-1];
                addb_pipe[i] <= addb_pipe[i-1];
                i_en_pipe[i] <= i_en_pipe[i-1];

                // Calculate carry_out of previous stage for bit (i-1)
                // carry_out = (a & b) | (a & carry_in) | (b & carry_in)
                // carry_in of stage i = carry_pipe[i-1]
                // inputs are bit (i-1) of operands at stage i-1

                // Calculate carry_out for bit i-1, save in carry_pipe[i]
                carry_pipe[i] <= (adda_pipe[i-1][i-1] & addb_pipe[i-1][i-1]) |
                                 (adda_pipe[i-1][i-1] & carry_pipe[i-1]) |
                                 (addb_pipe[i-1][i-1] & carry_pipe[i-1]);
            end

            // When output is valid (after 64 cycles), assemble result
            if (i_en_pipe[64]) begin
                // sum bits for bit i: sum_i = a_i ^ b_i ^ carry_i (carry_i is carry-in of stage i)
                // carry_pipe[i] is carry-out of stage i-1
                // sum bits can be computed by xor of operands bits and carry_pipe[i-1]

                for (i = 0; i < 64; i = i + 1) begin
                    // Calculate sum bit i:
                    // sum_i = a_i ^ b_i ^ carry_in_i = a_i ^ b_i ^ carry_pipe[i]
                    // carry_pipe[0] is carry-in for bit 0 (zero)
                    // carry_pipe[64] is final carry-out
                    result[i] <= adda_pipe[64][i] ^ addb_pipe[64][i] ^ carry_pipe[i];
                end
                // The MSB is the carry_out of last stage
                result[64] <= carry_pipe[64];
                o_en <= 1'b1;
            end else begin
                result <= result;
                o_en <= 1'b0;
            end
        end
    end

endmodule