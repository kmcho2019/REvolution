module multi_pipe_8bit (
    input wire clk,
    input wire rst_n,
    input wire mul_en_in,
    input wire [7:0] mul_a,
    input wire [7:0] mul_b,
    output reg mul_en_out,
    output reg [15:0] mul_out
);

    // Pipeline stage enables
    reg stage1_en, stage2_en, stage3_en, stage4_en;

    // Pipeline registers
    reg [7:0] a_reg, b_reg;
    reg [15:0] pp0_reg, pp1_reg, pp2_reg, pp3_reg;
    reg [15:0] sum01_reg, sum23_reg;
    reg [15:0] sum0123_reg;
    reg [15:0] result_reg;

    // Partial products (combinational)
    wire [15:0] pp0 = {8'b0, mul_a} & {16{mul_b[0]}};
    wire [15:0] pp1 = ({7'b0, mul_a, 1'b0}) & {16{mul_b[1]}};
    wire [15:0] pp2 = ({6'b0, mul_a, 2'b0}) & {16{mul_b[2]}};
    wire [15:0] pp3 = ({5'b0, mul_a, 3'b0}) & {16{mul_b[3]}};
    wire [15:0] pp4 = ({4'b0, mul_a, 4'b0}) & {16{mul_b[4]}};
    wire [15:0] pp5 = ({3'b0, mul_a, 5'b0}) & {16{mul_b[5]}};
    wire [15:0] pp6 = ({2'b0, mul_a, 6'b0}) & {16{mul_b[6]}};
    wire [15:0] pp7 = ({1'b0, mul_a, 7'b0}) & {16{mul_b[7]}};

    // Stage 1 sums
    wire [15:0] sum01 = pp0 + pp1;
    wire [15:0] sum23 = pp2 + pp3;
    wire [15:0] sum45 = pp4 + pp5;
    wire [15:0] sum67 = pp6 + pp7;

    // Stage 2 sums
    wire [15:0] sum0123 = sum01_reg + sum23_reg;
    wire [15:0] sum4567 = pp4_reg + pp5_reg + pp6_reg + pp7_reg;

    // Final sum
    wire [15:0] final_sum = sum0123_reg + sum4567_reg;

    // Pipeline control
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers
            a_reg <= 8'b0;
            b_reg <= 8'b0;
            pp0_reg <= 16'b0;
            pp1_reg <= 16'b0;
            pp2_reg <= 16'b0;
            pp3_reg <= 16'b0;
            sum01_reg <= 16'b0;
            sum23_reg <= 16'b0;
            sum0123_reg <= 16'b0;
            result_reg <= 16'b0;
            stage1_en <= 1'b0;
            stage2_en <= 1'b0;
            stage3_en <= 1'b0;
            stage4_en <= 1'b0;
        end else begin
            // Stage 1: Input registration
            a_reg <= mul_a;
            b_reg <= mul_b;
            stage1_en <= mul_en_in;

            // Stage 2: Partial product registration
            pp0_reg <= pp0;
            pp1_reg <= pp1;
            pp2_reg <= pp2;
            pp3_reg <= pp3;
            pp4_reg <= pp4;
            pp5_reg <= pp5;
            pp6_reg <= pp6;
            pp7_reg <= pp7;
            stage2_en <= stage1_en;

            // Stage 3: First level sums
            sum01_reg <= sum01;
            sum23_reg <= sum23;
            stage3_en <= stage2_en;

            // Stage 4: Second level sums
            sum0123_reg <= sum0123;
            sum4567_reg <= sum4567;
            stage4_en <= stage3_en;

            // Stage 5: Final result
            result_reg <= final_sum;
            mul_en_out <= stage4_en;
        end
    end

    // Output assignment
    always @(*) begin
        mul_out = mul_en_out ? result_reg : 16'b0;
    end

endmodule