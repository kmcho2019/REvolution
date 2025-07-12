module multi_pipe_8bit (
    input wire clk,
    input wire rst_n,
    input wire mul_en_in,
    input wire [7:0] mul_a,
    input wire [7:0] mul_b,
    output wire mul_en_out,
    output wire [15:0] mul_out
);

    // Clock gating signal (simplified version)
    wire clk_gated = clk & (mul_en_in | |en_pipeline[2:0]);

    // Pipeline registers
    reg [7:0] a_reg1, b_reg1;          // Stage 1
    reg [15:0] pp01_reg2, pp23_reg2;    // Stage 2
    reg [15:0] pp45_reg2, pp67_reg2;
    reg [15:0] sum_low_reg3;            // Stage 3
    reg [15:0] sum_high_reg3;
    reg [15:0] result_reg4;             // Stage 4
    reg [3:0] en_pipeline;

    // Partial products with operand isolation
    wire [15:0] pp0 = en_pipeline[0] ? {8'b0, b_reg1[0] ? a_reg1 : 8'b0} : 16'b0;
    wire [15:0] pp1 = en_pipeline[0] ? {7'b0, b_reg1[1] ? a_reg1 : 8'b0, 1'b0} : 16'b0;
    wire [15:0] pp2 = en_pipeline[0] ? {6'b0, b_reg1[2] ? a_reg1 : 8'b0, 2'b0} : 16'b0;
    wire [15:0] pp3 = en_pipeline[0] ? {5'b0, b_reg1[3] ? a_reg1 : 8'b0, 3'b0} : 16'b0;
    wire [15:0] pp4 = en_pipeline[0] ? {4'b0, b_reg1[4] ? a_reg1 : 8'b0, 4'b0} : 16'b0;
    wire [15:0] pp5 = en_pipeline[0] ? {3'b0, b_reg1[5] ? a_reg1 : 8'b0, 5'b0} : 16'b0;
    wire [15:0] pp6 = en_pipeline[0] ? {2'b0, b_reg1[6] ? a_reg1 : 8'b0, 6'b0} : 16'b0;
    wire [15:0] pp7 = en_pipeline[0] ? {1'b0, b_reg1[7] ? a_reg1 : 8'b0, 7'b0} : 16'b0;

    // Stage 1 sums
    wire [15:0] sum01 = pp0 + pp1;
    wire [15:0] sum23 = pp2 + pp3;
    wire [15:0] sum45 = pp4 + pp5;
    wire [15:0] sum67 = pp6 + pp7;

    // Stage 2 sums
    wire [15:0] sum_low = pp01_reg2 + pp23_reg2;
    wire [15:0] sum_high = pp45_reg2 + pp67_reg2;

    // Final sum
    wire [15:0] final_sum = sum_low_reg3 + sum_high_reg3;

    // Pipeline control
    always @(posedge clk_gated or negedge rst_n) begin
        if (!rst_n) begin
            a_reg1 <= 8'b0;
            b_reg1 <= 8'b0;
            pp01_reg2 <= 16'b0;
            pp23_reg2 <= 16'b0;
            pp45_reg2 <= 16'b0;
            pp67_reg2 <= 16'b0;
            sum_low_reg3 <= 16'b0;
            sum_high_reg3 <= 16'b0;
            result_reg4 <= 16'b0;
            en_pipeline <= 4'b0;
        end else begin
            // Stage 1: Input registration
            a_reg1 <= mul_a;
            b_reg1 <= mul_b;

            // Stage 2: Register first level sums
            pp01_reg2 <= sum01;
            pp23_reg2 <= sum23;
            pp45_reg2 <= sum45;
            pp67_reg2 <= sum67;

            // Stage 3: Register second level sums
            sum_low_reg3 <= sum_low;
            sum_high_reg3 <= sum_high;

            // Stage 4: Register final result
            result_reg4 <= final_sum;

            // Enable signal pipeline
            en_pipeline <= {en_pipeline[2:0], mul_en_in};
        end
    end

    // Output assignments
    assign mul_en_out = en_pipeline[3];
    assign mul_out = en_pipeline[3] ? result_reg4 : 16'b0;

endmodule