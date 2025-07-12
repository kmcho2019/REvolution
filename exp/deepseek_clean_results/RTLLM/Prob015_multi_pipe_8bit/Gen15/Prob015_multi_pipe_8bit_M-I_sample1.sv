module multi_pipe_8bit (
    input wire clk,
    input wire rst_n,
    input wire mul_en_in,
    input wire [7:0] mul_a,
    input wire [7:0] mul_b,
    output reg mul_en_out,
    output reg [15:0] mul_out
);

    // Pipeline stage registers (optimized structure)
    reg [7:0] a_reg1, b_reg1;
    reg [15:0] pp_regfile [3:0]; // Merged register file
    reg [15:0] sum_low_reg3, sum_high_reg3;
    reg [15:0] carry_reg3; // Carry-save register
    reg [15:0] final_sum_reg4;
    reg [15:0] result_reg5;
    reg [4:0] en_pipeline; // 1-bit per stage

    // Dynamic partial product generation
    wire [15:0] pp [7:0];
    generate
        for (genvar i = 0; i < 8; i = i + 1) begin : pp_gen
            assign pp[i] = (en_pipeline[0] & b_reg1[i]) ? ({8'b0, a_reg1} << i) : 16'b0;
        end
    endgenerate

    // Stage 1: Carry-save adders (3:2 compressors)
    wire [15:0] sum01, carry01;
    assign {carry01, sum01} = pp[0] + pp[1] + pp[2];
    
    wire [15:0] sum23, carry23;
    assign {carry23, sum23} = pp[3] + pp[4] + pp[5];

    wire [15:0] sum67 = pp[6] + pp[7]; // Only 2 operands

    // Pipeline control with synchronous enables
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers
            a_reg1 <= 8'b0;
            b_reg1 <= 8'b0;
            pp_regfile[0] <= 16'b0;
            pp_regfile[1] <= 16'b0;
            pp_regfile[2] <= 16'b0;
            pp_regfile[3] <= 16'b0;
            sum_low_reg3 <= 16'b0;
            sum_high_reg3 <= 16'b0;
            carry_reg3 <= 16'b0;
            final_sum_reg4 <= 16'b0;
            result_reg5 <= 16'b0;
            en_pipeline <= 5'b0;
        end else begin
            // Stage 1: Input registration
            if (mul_en_in) begin
                a_reg1 <= mul_a;
                b_reg1 <= mul_b;
            end

            // Stage 2: Partial sums registration (merged)
            if (en_pipeline[0]) begin
                pp_regfile[0] <= sum01;
                pp_regfile[1] <= carry01;
                pp_regfile[2] <= sum23;
                pp_regfile[3] <= carry23;
            end

            // Stage 3: Intermediate sums with carry-save
            if (en_pipeline[1]) begin
                sum_low_reg3 <= pp_regfile[0] + pp_regfile[1];
                sum_high_reg3 <= pp_regfile[2] + pp_regfile[3];
                carry_reg3 <= sum67; // Carry from previous stage
            end

            // Stage 4: Final sum computation
            if (en_pipeline[2]) begin
                final_sum_reg4 <= sum_low_reg3 + sum_high_reg3 + carry_reg3;
            end

            // Stage 5: Result registration
            if (en_pipeline[3]) begin
                result_reg5 <= final_sum_reg4;
            end

            // Enable shift register (1-bit per stage)
            en_pipeline <= {en_pipeline[3:0], mul_en_in};
        end
    end

    // Output assignment with operand isolation
    always @(*) begin
        mul_en_out = en_pipeline[4];
        mul_out = en_pipeline[4] ? result_reg5 : 16'b0;
    end

endmodule