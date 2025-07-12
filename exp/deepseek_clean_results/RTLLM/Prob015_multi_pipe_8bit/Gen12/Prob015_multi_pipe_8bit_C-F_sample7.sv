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
    reg [15:0] sum_low_reg2, sum_high_reg2;
    reg [15:0] result_reg3;
    reg [2:0] en_pipeline;  // Compact 3-stage enable tracking

    // Conditional partial product generation (optimized)
    wire [15:0] pp [7:0];
    generate
        for (genvar i = 0; i < 8; i = i + 1) begin : pp_gen
            assign pp[i] = b_reg1[i] ? ({8'b0, a_reg1} << i) : 16'b0;
        end
    endgenerate

    // Balanced adder tree (stage 1)
    wire [15:0] sum_low = pp[0] + pp[1] + pp[2] + pp[3];
    wire [15:0] sum_high = pp[4] + pp[5] + pp[6] + pp[7];

    // Final sum (stage 2)
    wire [15:0] final_sum = sum_low_reg2 + sum_high_reg2;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all pipeline registers
            a_reg1 <= 8'b0;
            b_reg1 <= 8'b0;
            sum_low_reg2 <= 16'b0;
            sum_high_reg2 <= 16'b0;
            result_reg3 <= 16'b0;
            en_pipeline <= 3'b0;
        end else begin
            // Stage 1: Input registration and partial product computation
            a_reg1 <= mul_a;
            b_reg1 <= mul_b;

            // Stage 2: Intermediate sums registration
            sum_low_reg2 <= sum_low;
            sum_high_reg2 <= sum_high;

            // Stage 3: Final result
            result_reg3 <= final_sum;

            // Enable propagation through pipeline
            en_pipeline <= {en_pipeline[1:0], mul_en_in};
        end
    end

    // Output with operand isolation
    always @(*) begin
        mul_en_out = en_pipeline[2];
        mul_out = en_pipeline[2] ? result_reg3 : 16'b0;
    end

endmodule