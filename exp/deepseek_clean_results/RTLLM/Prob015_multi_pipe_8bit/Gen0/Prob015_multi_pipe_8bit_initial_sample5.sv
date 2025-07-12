module multi_pipe_8bit (
    input clk,
    input rst_n,
    input mul_en_in,
    input [7:0] mul_a,
    input [7:0] mul_b,
    output reg mul_en_out,
    output reg [15:0] mul_out
);

// Input registers
reg [7:0] mul_a_reg, mul_b_reg;
reg mul_en_reg;

// Partial products
wire [7:0] pp0, pp1, pp2, pp3, pp4, pp5, pp6, pp7;

// Pipeline stages
reg [15:0] stage1;
reg [15:0] stage2;

// Generate partial products
assign pp0 = mul_b_reg[0] ? mul_a_reg : 8'b0;
assign pp1 = mul_b_reg[1] ? mul_a_reg : 8'b0;
assign pp2 = mul_b_reg[2] ? mul_a_reg : 8'b0;
assign pp3 = mul_b_reg[3] ? mul_a_reg : 8'b0;
assign pp4 = mul_b_reg[4] ? mul_a_reg : 8'b0;
assign pp5 = mul_b_reg[5] ? mul_a_reg : 8'b0;
assign pp6 = mul_b_reg[6] ? mul_a_reg : 8'b0;
assign pp7 = mul_b_reg[7] ? mul_a_reg : 8'b0;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all registers
        mul_a_reg <= 8'b0;
        mul_b_reg <= 8'b0;
        mul_en_reg <= 1'b0;
        stage1 <= 16'b0;
        stage2 <= 16'b0;
        mul_out <= 16'b0;
        mul_en_out <= 1'b0;
    end
    else begin
        // Pipeline stage 0: Input registers
        mul_en_reg <= mul_en_in;
        if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end

        // Pipeline stage 1: First level of addition
        stage1 <= {8'b0, pp0} + ({7'b0, pp1, 1'b0}) + ({6'b0, pp2, 2'b0}) + ({5'b0, pp3, 3'b0});

        // Pipeline stage 2: Second level of addition
        stage2 <= stage1 + ({4'b0, pp4, 4'b0}) + ({3'b0, pp5, 5'b0}) + ({2'b0, pp6, 6'b0}) + ({1'b0, pp7, 7'b0});

        // Pipeline stage 3: Output register
        mul_out <= stage2;
        mul_en_out <= mul_en_reg;
    end
end

endmodule