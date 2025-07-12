module adder_pipe_64bit (
    input               clk,
    input               rst_n,
    input               i_en,
    input       [63:0]  adda,
    input       [63:0]  addb,
    output reg  [64:0]  result,
    output reg          o_en
);

    // Pipeline registers for inputs and enable
    reg [63:0] adda_1, adda_2, adda_3, adda_4;
    reg [63:0] addb_1, addb_2, addb_3, addb_4;
    reg        en_1, en_2, en_3, en_4;

    // Carry signals between pipeline stages
    reg carry_0, carry_1, carry_2, carry_3, carry_4;

    // Partial sums for each stage
    reg [15:0] sum_0, sum_1, sum_2, sum_3;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            adda_1 <= 64'b0;
            addb_1 <= 64'b0;
            adda_2 <= 64'b0;
            addb_2 <= 64'b0;
            adda_3 <= 64'b0;
            addb_3 <= 64'b0;
            adda_4 <= 64'b0;
            addb_4 <= 64'b0;

            en_1 <= 1'b0;
            en_2 <= 1'b0;
            en_3 <= 1'b0;
            en_4 <= 1'b0;

            carry_0 <= 1'b0;
            carry_1 <= 1'b0;
            carry_2 <= 1'b0;
            carry_3 <= 1'b0;
            carry_4 <= 1'b0;

            sum_0 <= 16'b0;
            sum_1 <= 16'b0;
            sum_2 <= 16'b0;
            sum_3 <= 16'b0;

            result <= 65'b0;
            o_en <= 1'b0;
        end else begin
            // Stage 1 input registers
            adda_1 <= adda;
            addb_1 <= addb;
            en_1 <= i_en;

            // Stage 1 addition (bits 15:0)
            {carry_1, sum_0} <= adda_1[15:0] + addb_1[15:0] + carry_0;

            // Stage 2 input registers
            adda_2 <= adda_1;
            addb_2 <= addb_1;
            en_2 <= en_1;

            // Stage 2 addition (bits 31:16)
            {carry_2, sum_1} <= adda_2[31:16] + addb_2[31:16] + carry_1;

            // Stage 3 input registers
            adda_3 <= adda_2;
            addb_3 <= addb_2;
            en_3 <= en_2;

            // Stage 3 addition (bits 47:32)
            {carry_3, sum_2} <= adda_3[47:32] + addb_3[47:32] + carry_2;

            // Stage 4 input registers
            adda_4 <= adda_3;
            addb_4 <= addb_3;
            en_4 <= en_3;

            // Stage 4 addition (bits 63:48)
            {carry_4, sum_3} <= adda_4[63:48] + addb_4[63:48] + carry_3;

            // Final result concatenation
            result <= {carry_4, sum_3, sum_2, sum_1, sum_0};
            o_en <= en_4;
        end
    end

endmodule