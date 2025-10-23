module multi_pipe_8bit (
    input wire clk,
    input wire rst_n,
    input wire mul_en_in,
    input wire [7:0] mul_a,
    input wire [7:0] mul_b,
    output reg mul_en_out,
    output reg [15:0] mul_out
);

    // Input registers
    reg [7:0] mul_a_reg, mul_b_reg;
    reg en_reg;
    
    // Partial products
    wire [15:0] pp0 = {8'b0, mul_b_reg[0] ? mul_a_reg : 8'b0};
    wire [15:0] pp1 = {7'b0, mul_b_reg[1] ? mul_a_reg : 8'b0, 1'b0};
    wire [15:0] pp2 = {6'b0, mul_b_reg[2] ? mul_a_reg : 8'b0, 2'b0};
    wire [15:0] pp3 = {5'b0, mul_b_reg[3] ? mul_a_reg : 8'b0, 3'b0};
    wire [15:0] pp4 = {4'b0, mul_b_reg[4] ? mul_a_reg : 8'b0, 4'b0};
    wire [15:0] pp5 = {3'b0, mul_b_reg[5] ? mul_a_reg : 8'b0, 5'b0};
    wire [15:0] pp6 = {2'b0, mul_b_reg[6] ? mul_a_reg : 8'b0, 6'b0};
    wire [15:0] pp7 = {1'b0, mul_b_reg[7] ? mul_a_reg : 8'b0, 7'b0};
    
    // Sum all partial products
    wire [15:0] product = pp0 + pp1 + pp2 + pp3 + pp4 + pp5 + pp6 + pp7;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_a_reg <= 8'b0;
            mul_b_reg <= 8'b0;
            en_reg <= 1'b0;
            mul_out <= 16'b0;
            mul_en_out <= 1'b0;
        end else begin
            // Register inputs and enable
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
            en_reg <= mul_en_in;
            
            // Register output
            mul_out <= en_reg ? product : 16'b0;
            mul_en_out <= en_reg;
        end
    end

endmodule