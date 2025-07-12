module multi_pipe_8bit (
    input wire clk,
    input wire rst_n,
    input wire mul_en_in,
    input wire [7:0] mul_a,
    input wire [7:0] mul_b,
    output reg mul_en_out,
    output reg [15:0] mul_out
);

    // Pipeline stage 1 registers (input)
    reg [7:0] mul_a_reg, mul_b_reg;
    reg en_reg;
    
    // Pipeline stage 2 registers (result)
    reg [15:0] result_reg;
    reg en_out_reg;
    
    // Partial products with operand isolation
    wire [15:0] pp[0:7];
    assign pp[0] = mul_b_reg[0] ? {8'b0, mul_a_reg} : 16'b0;
    assign pp[1] = mul_b_reg[1] ? {7'b0, mul_a_reg, 1'b0} : 16'b0;
    assign pp[2] = mul_b_reg[2] ? {6'b0, mul_a_reg, 2'b0} : 16'b0;
    assign pp[3] = mul_b_reg[3] ? {5'b0, mul_a_reg, 3'b0} : 16'b0;
    assign pp[4] = mul_b_reg[4] ? {4'b0, mul_a_reg, 4'b0} : 16'b0;
    assign pp[5] = mul_b_reg[5] ? {3'b0, mul_a_reg, 5'b0} : 16'b0;
    assign pp[6] = mul_b_reg[6] ? {2'b0, mul_a_reg, 6'b0} : 16'b0;
    assign pp[7] = mul_b_reg[7] ? {1'b0, mul_a_reg, 7'b0} : 16'b0;
    
    // Sum all partial products
    wire [15:0] sum = pp[0] + pp[1] + pp[2] + pp[3] + 
                     pp[4] + pp[5] + pp[6] + pp[7];
    
    // Pipeline control
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers
            mul_a_reg <= 8'b0;
            mul_b_reg <= 8'b0;
            result_reg <= 16'b0;
            
            // Enable pipeline
            en_reg <= 1'b0;
            en_out_reg <= 1'b0;
        end else begin
            // Stage 1: Input registration
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
            en_reg <= mul_en_in;
            
            // Stage 2: Result registration
            result_reg <= sum;
            en_out_reg <= en_reg;
        end
    end
    
    // Output assignment
    always @(*) begin
        mul_en_out = en_out_reg;
        mul_out = result_reg;
    end

endmodule