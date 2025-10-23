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
    reg [7:0] a_reg, b_reg;
    reg [15:0] sum01_reg, sum23_reg, sum45_reg, sum67_reg;
    reg [15:0] final_sum_reg;
    
    // Enable signal pipeline (3 stages)
    reg [2:0] en_pipeline;

    // Parameterized partial product generation
    wire [15:0] pp [7:0];
    generate
        for (genvar i = 0; i < 8; i = i + 1) begin : pp_gen
            assign pp[i] = (en_pipeline[0] & b_reg[i]) ? ({8'b0, a_reg} << i) : 16'b0;
        end
    endgenerate

    // First level sums
    wire [15:0] sum01 = pp[0] + pp[1];
    wire [15:0] sum23 = pp[2] + pp[3];
    wire [15:0] sum45 = pp[4] + pp[5];
    wire [15:0] sum67 = pp[6] + pp[7];

    // Second level sums
    wire [15:0] sum_low = sum01_reg + sum23_reg;
    wire [15:0] sum_high = sum45_reg + sum67_reg;

    // Final sum
    wire [15:0] final_sum = sum_low + sum_high;

    // Pipeline control
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers
            a_reg <= 8'b0;
            b_reg <= 8'b0;
            sum01_reg <= 16'b0;
            sum23_reg <= 16'b0;
            sum45_reg <= 16'b0;
            sum67_reg <= 16'b0;
            final_sum_reg <= 16'b0;
            en_pipeline <= 3'b0;
        end else begin
            // Stage 1: Input registration
            a_reg <= mul_a;
            b_reg <= mul_b;
            
            // Stage 2: First level sums registration
            sum01_reg <= sum01;
            sum23_reg <= sum23;
            sum45_reg <= sum45;
            sum67_reg <= sum67;
            
            // Stage 3: Final result registration
            final_sum_reg <= final_sum;
            
            // Enable signal propagation
            en_pipeline <= {en_pipeline[1:0], mul_en_in};
        end
    end

    // Output assignment
    always @(*) begin
        mul_en_out = en_pipeline[2];
        mul_out = en_pipeline[2] ? final_sum_reg : 16'b0;
    end

endmodule