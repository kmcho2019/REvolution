module multi_pipe_8bit (
    input wire clk,
    input wire rst_n,
    input wire mul_en_in,
    input wire [7:0] mul_a,
    input wire [7:0] mul_b,
    output reg mul_en_out,
    output reg [15:0] mul_out
);

    // Pipeline stage 1 registers (inputs)
    reg [7:0] mul_a_reg, mul_b_reg;
    reg en_reg1;
    
    // Pipeline stage 2 registers (partial products)
    reg [15:0] pp0, pp1, pp2, pp3;
    reg en_reg2;
    
    // Pipeline stage 3 registers (final sum)
    reg [15:0] sum_reg;
    reg en_reg3;
    
    // Partial products with operand isolation
    wire [15:0] pp [3:0];
    assign pp[0] = (mul_en_in & mul_b_reg[0]) ? {8'b0, mul_a_reg} : 16'b0;
    assign pp[1] = (mul_en_in & mul_b_reg[1]) ? {7'b0, mul_a_reg, 1'b0} : 16'b0;
    assign pp[2] = (mul_en_in & mul_b_reg[2]) ? {6'b0, mul_a_reg, 2'b0} : 16'b0;
    assign pp[3] = (mul_en_in & mul_b_reg[3]) ? {5'b0, mul_a_reg, 3'b0} : 16'b0;
    
    wire [15:0] pp4 = (mul_en_in & mul_b_reg[4]) ? {4'b0, mul_a_reg, 4'b0} : 16'b0;
    wire [15:0] pp5 = (mul_en_in & mul_b_reg[5]) ? {3'b0, mul_a_reg, 5'b0} : 16'b0;
    wire [15:0] pp6 = (mul_en_in & mul_b_reg[6]) ? {2'b0, mul_a_reg, 6'b0} : 16'b0;
    wire [15:0] pp7 = (mul_en_in & mul_b_reg[7]) ? {1'b0, mul_a_reg, 7'b0} : 16'b0;
    
    // Intermediate sums
    wire [15:0] sum01 = pp[0] + pp[1];
    wire [15:0] sum23 = pp[2] + pp[3];
    wire [15:0] sum45 = pp4 + pp5;
    wire [15:0] sum67 = pp6 + pp7;
    
    // Final sum
    wire [15:0] sum_low = sum01 + sum23;
    wire [15:0] sum_high = sum45 + sum67;
    wire [15:0] final_sum = sum_low + sum_high;
    
    // Pipeline control
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers
            mul_a_reg <= 8'b0;
            mul_b_reg <= 8'b0;
            pp0 <= 16'b0;
            pp1 <= 16'b0;
            pp2 <= 16'b0;
            pp3 <= 16'b0;
            sum_reg <= 16'b0;
            
            // Reset enable signals
            en_reg1 <= 1'b0;
            en_reg2 <= 1'b0;
            en_reg3 <= 1'b0;
        end else begin
            // Stage 1: Input registration
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
            en_reg1 <= mul_en_in;
            
            // Stage 2: Partial product registration
            pp0 <= sum01;
            pp1 <= sum23;
            pp2 <= sum45;
            pp3 <= sum67;
            en_reg2 <= en_reg1;
            
            // Stage 3: Final sum registration
            sum_reg <= final_sum;
            en_reg3 <= en_reg2;
        end
    end
    
    // Output assignment
    always @(*) begin
        mul_en_out = en_reg3;
        mul_out = en_reg3 ? sum_reg : 16'b0;
    end

endmodule