module adder_pipe_64bit (
    input               clk,
    input               rst_n,
    input               i_en,
    input       [63:0]  adda,
    input       [63:0]  addb,
    output reg  [64:0]  result,
    output reg          o_en
);

    // Pipeline registers for each 16-bit stage inputs
    reg [15:0] adda_0, addb_0;
    reg [15:0] adda_1, addb_1;
    reg [15:0] adda_2, addb_2;
    reg [15:0] adda_3, addb_3;

    // Pipeline registers for sums at each stage
    reg [15:0] sum_0, sum_1, sum_2, sum_3;

    // Pipeline registers for carry signals between stages
    reg carry_0, carry_1, carry_2, carry_3;

    // Pipeline registers for enable signal through stages
    reg en_0, en_1, en_2, en_3;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all pipeline registers
            adda_0 <= 16'b0;
            addb_0 <= 16'b0;
            adda_1 <= 16'b0;
            addb_1 <= 16'b0;
            adda_2 <= 16'b0;
            addb_2 <= 16'b0;
            adda_3 <= 16'b0;
            addb_3 <= 16'b0;

            sum_0 <= 16'b0;
            sum_1 <= 16'b0;
            sum_2 <= 16'b0;
            sum_3 <= 16'b0;

            carry_0 <= 1'b0;
            carry_1 <= 1'b0;
            carry_2 <= 1'b0;
            carry_3 <= 1'b0;

            en_0 <= 1'b0;
            en_1 <= 1'b0;
            en_2 <= 1'b0;
            en_3 <= 1'b0;

            result <= 65'b0;
            o_en <= 1'b0;
        end else begin
            // Stage 0: latch inputs and perform addition with carry_in=0
            adda_0 <= adda[15:0];
            addb_0 <= addb[15:0];
            {carry_0, sum_0} <= adda[15:0] + addb[15:0] + 1'b0;
            en_0 <= i_en;

            // Stage 1: latch inputs, add with carry from stage 0
            adda_1 <= adda[31:16];
            addb_1 <= addb[31:16];
            {carry_1, sum_1} <= adda_1 + addb_1 + carry_0;
            en_1 <= en_0;

            // Stage 2: latch inputs, add with carry from stage 1
            adda_2 <= adda[47:32];
            addb_2 <= addb[47:32];
            {carry_2, sum_2} <= adda_2 + addb_2 + carry_1;
            en_2 <= en_1;

            // Stage 3: latch inputs, add with carry from stage 2
            adda_3 <= adda[63:48];
            addb_3 <= addb[63:48];
            {carry_3, sum_3} <= adda_3 + addb_3 + carry_2;
            en_3 <= en_2;

            // Assemble final result and output enable when stage 3 valid
            result <= {carry_3, sum_3, sum_2, sum_1, sum_0};
            o_en <= en_3;
        end
    end

endmodule