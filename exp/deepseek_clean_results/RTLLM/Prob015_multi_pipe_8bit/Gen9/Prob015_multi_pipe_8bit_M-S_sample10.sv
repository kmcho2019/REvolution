module multi_pipe_8bit (
    input wire clk,
    input wire rst_n,
    input wire mul_en_in,
    input wire [7:0] mul_a,
    input wire [7:0] mul_b,
    output reg mul_en_out,
    output reg [15:0] mul_out
);

    // Pipeline stage 1 registers
    reg [7:0] mul_a_reg1, mul_b_reg1;
    reg en_reg1;
    
    // Pipeline stage 2 registers (partial sums)
    reg [15:0] sum_low_reg2, sum_high_reg2;
    reg en_reg2;
    
    // Pipeline stage 3 registers (final sum)
    reg [15:0] final_sum_reg3;
    reg en_reg3;
    
    // Partial products (combinational)
    wire [15:0] pp0 = mul_b_reg1[0] ? {8'b0, mul_a_reg1} : 16'b0;
    wire [15:0] pp1 = mul_b_reg1[1] ? {7'b0, mul_a_reg1, 1'b0} : 16'b0;
    wire [15:0] pp2 = mul_b_reg1[2] ? {6'b0, mul_a_reg1, 2'b0} : 16'b0;
    wire [15:0] pp3 = mul_b_reg1[3] ? {5'b0, mul_a_reg1, 3'b0} : 16'b0;
    wire [15:0] pp4 = mul_b_reg1[4] ? {4'b0, mul_a_reg1, 4'b0} : 16'b0;
    wire [15:0] pp5 = mul_b_reg1[5] ? {3'b0, mul_a_reg1, 5'b0} : 16'b0;
    wire [15:0] pp6 = mul_b_reg1[6] ? {2'b0, mul_a_reg1, 6'b0} : 16'b0;
    wire [15:0] pp7 = mul_b_reg1[7] ? {1'b0, mul_a_reg1, 7'b0} : 16'b0;
    
    // First level sums (combinational)
    wire [15:0] sum01 = pp0 + pp1;
    wire [15:0] sum23 = pp2 + pp3;
    wire [15:0] sum45 = pp4 + pp5;
    wire [15:0] sum67 = pp6 + pp7;
    
    // Second level sums (combinational)
    wire [15:0] sum_low = sum01 + sum23;
    wire [15:0] sum_high = sum45 + sum67;
    
    // Final sum (combinational)
    wire [15:0] final_sum = sum_low_reg2 + sum_high_reg2;
    
    // Pipeline control
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers
            mul_a_reg1 <= 8'b0;
            mul_b_reg1 <= 8'b0;
            sum_low_reg2 <= 16'b0;
            sum_high_reg2 <= 16'b0;
            final_sum_reg3 <= 16'b0;
            
            // Reset enable signals
            en_reg1 <= 1'b0;
            en_reg2 <= 1'b0;
            en_reg3 <= 1'b0;
        end else begin
            // Stage 1: Input registration
            mul_a_reg1 <= mul_a;
            mul_b_reg1 <= mul_b;
            en_reg1 <= mul_en_in;
            
            // Stage 2: Intermediate sums registration
            sum_low_reg2 <= sum_low;
            sum_high_reg2 <= sum_high;
            en_reg2 <= en_reg1;
            
            // Stage 3: Final result registration
            final_sum_reg3 <= final_sum;
            en_reg3 <= en_reg2;
        end
    end
    
    // Output assignment
    always @(*) begin
        mul_en_out = en_reg3;
        mul_out = en_reg3 ? final_sum_reg3 : 16'b0;
    end

endmodule