module adder_pipe_64bit (
    input               clk,
    input               rst_n,
    input               i_en,
    input       [63:0]  adda,
    input       [63:0]  addb,
    output reg  [64:0]  result,
    output reg          o_en
);

    // Pipeline registers for inputs and enables
    reg [63:0] adda_r1, adda_r2, adda_r3;
    reg [63:0] addb_r1, addb_r2, addb_r3;
    reg        en_r1, en_r2, en_r3, en_r4;

    // Carry registers between stages
    reg carry0, carry1, carry2, carry3;

    // Partial sums for each 16-bit stage
    reg [15:0] sum0, sum1, sum2, sum3;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all pipeline registers and outputs
            adda_r1 <= 64'b0;
            adda_r2 <= 64'b0;
            adda_r3 <= 64'b0;
            addb_r1 <= 64'b0;
            addb_r2 <= 64'b0;
            addb_r3 <= 64'b0;

            en_r1 <= 1'b0;
            en_r2 <= 1'b0;
            en_r3 <= 1'b0;
            en_r4 <= 1'b0;

            carry0 <= 1'b0;
            carry1 <= 1'b0;
            carry2 <= 1'b0;
            carry3 <= 1'b0;

            sum0 <= 16'b0;
            sum1 <= 16'b0;
            sum2 <= 16'b0;
            sum3 <= 16'b0;

            result <= 65'b0;
            o_en <= 1'b0;
        end else begin
            // Stage 1 registers and addition (bits 15:0)
            adda_r1 <= adda;
            addb_r1 <= addb;
            en_r1 <= i_en;
            {carry1, sum0} <= adda[15:0] + addb[15:0] + 1'b0;

            // Stage 2 registers and addition (bits 31:16)
            adda_r2 <= adda_r1;
            addb_r2 <= addb_r1;
            en_r2 <= en_r1;
            {carry2, sum1} <= adda_r1[31:16] + addb_r1[31:16] + carry1;

            // Stage 3 registers and addition (bits 47:32)
            adda_r3 <= adda_r2;
            addb_r3 <= addb_r2;
            en_r3 <= en_r2;
            {carry3, sum2} <= adda_r2[47:32] + addb_r2[47:32] + carry2;

            // Stage 4 addition (bits 63:48)
            en_r4 <= en_r3;
            {carry0, sum3} <= adda_r3[63:48] + addb_r3[63:48] + carry3;

            // Final output
            result <= {carry0, sum3, sum2, sum1, sum0};
            o_en <= en_r4;
        end
    end

endmodule