module multi_pipe_8bit (
    input wire clk,
    input wire rst_n,
    input wire mul_en_in,
    input wire [7:0] mul_a,
    input wire [7:0] mul_b,
    output reg mul_en_out,
    output reg [15:0] mul_out
);

    // Pipeline stage registers
    reg [7:0] a_reg1, b_reg1;
    reg [15:0] pp01_reg2, pp23_reg2;
    reg [15:0] pp45_reg2, pp67_reg2;
    reg [15:0] sum_low_reg3, sum_high_reg3;
    reg [15:0] result_reg4;
    reg [3:0] en_pipeline;

    // Conditional partial product generation (optimized)
    wire [15:0] pp [7:0];
    generate
        for (genvar i = 0; i < 8; i = i + 1) begin : pp_gen
            assign pp[i] = b_reg1[i] ? ({8'b0, a_reg1} << i) : 16'b0;
        end
    endgenerate

    // Balanced adder tree (stage 1)
    wire [15:0] sum01 = pp[0] + pp[1];
    wire [15:0] sum23 = pp[2] + pp[3];
    wire [15:0] sum45 = pp[4] + pp[5];
    wire [15:0] sum67 = pp[6] + pp[7];

    // Intermediate sums (stage 2)
    wire [15:0] sum_low = pp01_reg2 + pp23_reg2;
    wire [15:0] sum_high = pp45_reg2 + pp67_reg2;

    // Final sum (stage 3)
    wire [15:0] final_sum = sum_low_reg3 + sum_high_reg3;

    // Pipeline control
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers
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
            // Stage 1: Input registration (only when enabled)
            if (mul_en_in || |en_pipeline) begin
                a_reg1 <= mul_a;
                b_reg1 <= mul_b;
            end

            // Stage 2: Partial sums registration
            pp01_reg2 <= sum01;
            pp23_reg2 <= sum23;
            pp45_reg2 <= sum45;
            pp67_reg2 <= sum67;

            // Stage 3: Intermediate sums
            sum_low_reg3 <= sum_low;
            sum_high_reg3 <= sum_high;

            // Stage 4: Final result
            result_reg4 <= final_sum;

            // Enable shift register (compact version)
            en_pipeline <= {en_pipeline[2:0], mul_en_in};
        end
    end

    // Output assignment with operand isolation
    always @(*) begin
        mul_en_out = en_pipeline[3];
        mul_out = en_pipeline[3] ? result_reg4 : 16'b0;
    end

endmodule