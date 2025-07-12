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
    reg en_reg;
    
    // Partial products
    wire [15:0] pp0 = {8'b0, a_reg & {8{b_reg[0]}};
    wire [15:0] pp1 = {7'b0, a_reg & {8{b_reg[1]}, 1'b0};
    wire [15:0] pp2 = {6'b0, a_reg & {8{b_reg[2]}, 2'b0};
    wire [15:0] pp3 = {5'b0, a_reg & {8{b_reg[3]}, 3'b0};
    wire [15:0] pp4 = {4'b0, a_reg & {8{b_reg[4]}, 4'b0};
    wire [15:0] pp5 = {3'b0, a_reg & {8{b_reg[5]}, 5'b0};
    wire [15:0] pp6 = {2'b0, a_reg & {8{b_reg[6]}, 6'b0};
    wire [15:0] pp7 = {1'b0, a_reg & {8{b_reg[7]}, 7'b0};

    // Intermediate sum
    wire [15:0] sum = pp0 + pp1 + pp2 + pp3 + pp4 + pp5 + pp6 + pp7;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers
            a_reg <= 8'b0;
            b_reg <= 8'b0;
            en_reg <= 1'b0;
            mul_out <= 16'b0;
            mul_en_out <= 1'b0;
        end else begin
            // Stage 1: Input registration
            a_reg <= mul_a;
            b_reg <= mul_b;
            en_reg <= mul_en_in;
            
            // Stage 2: Output registration
            mul_out <= sum;
            mul_en_out <= en_reg;
        end
    end

endmodule