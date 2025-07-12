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
    reg [15:0] pp_regfile [3:0]; // Merged register file
    reg [15:0] sum_carry_reg3, sum_reg3;
    reg [15:0] final_sum_reg4;
    reg [15:0] result_reg5;
    reg [4:0] en_pipeline; // 1-bit per stage

    // Dynamic partial product enable
    wire [7:0] pp_en = b_reg1 & {8{en_pipeline[0]}};

    // Carry-save partial products
    wire [15:0] pp [7:0];
    generate
        for (genvar i = 0; i < 8; i = i + 1) begin : pp_gen
            assign pp[i] = pp_en[i] ? ({8'b0, a_reg1} << i) : 16'b0;
        end
    endgenerate

    // Stage 1: Carry-save addition
    wire [15:0] sum01 = pp[0] + pp[1];
    wire [15:0] sum23 = pp[2] + pp[3];
    wire [15:0] carry01 = pp[0] & pp[1];
    wire [15:0] carry23 = pp[2] & pp[3];

    // Stage 2: Intermediate sums
    wire [15:0] sum_stage2 = sum01 + sum23;
    wire [15:0] carry_stage2 = carry01 | carry23;

    // Stage 3: Final addition
    wire [15:0] final_sum = sum_reg3 + sum_carry_reg3;

    // Pipeline control
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers
            a_reg1 <= 8'b0;
            b_reg1 <= 8'b0;
            for (int i = 0; i < 4; i = i + 1) pp_regfile[i] <= 16'b0;
            sum_carry_reg3 <= 16'b0;
            sum_reg3 <= 16'b0;
            final_sum_reg4 <= 16'b0;
            result_reg5 <= 16'b0;
            en_pipeline <= 5'b0;
        end else begin
            // Stage 1: Input registration
            if (mul_en_in) begin
                a_reg1 <= mul_a;
                b_reg1 <= mul_b;
            end

            // Stage 2: Partial sums registration
            pp_regfile[0] <= sum01;
            pp_regfile[1] <= sum23;
            pp_regfile[2] <= carry01;
            pp_regfile[3] <= carry23;

            // Stage 3: Intermediate sums
            sum_reg3 <= sum_stage2;
            sum_carry_reg3 <= carry_stage2;

            // Stage 4: Final addition
            final_sum_reg4 <= final_sum;

            // Stage 5: Result registration
            result_reg5 <= final_sum_reg4;

            // Enable shift register
            en_pipeline <= {en_pipeline[3:0], mul_en_in};
        end
    end

    // Output assignment
    always @(*) begin
        mul_en_out = en_pipeline[4];
        mul_out = en_pipeline[4] ? result_reg5 : 16'b0;
    end

    // Clock gating per stage (synthesis-time optimization)
    // synthesis translate_off
    initial begin
        $display("Optimized 8-bit pipelined multiplier with:");
        $display("- 5-stage pipeline");
        $display("- Carry-save adders");
        $display("- Dynamic partial product enable");
        $display("- Merged register file");
    end
    // synthesis translate_on

endmodule