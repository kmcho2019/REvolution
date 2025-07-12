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
reg [7:0] a_reg, b_reg;
reg en_reg;

// Partial products
wire [15:0] pp0 = b_reg[0] ? {8'b0, a_reg} : 16'b0;
wire [15:0] pp1 = b_reg[1] ? {7'b0, a_reg, 1'b0} : 16'b0;
wire [15:0] pp2 = b_reg[2] ? {6'b0, a_reg, 2'b0} : 16'b0;
wire [15:0] pp3 = b_reg[3] ? {5'b0, a_reg, 3'b0} : 16'b0;
wire [15:0] pp4 = b_reg[4] ? {4'b0, a_reg, 4'b0} : 16'b0;
wire [15:0] pp5 = b_reg[5] ? {3'b0, a_reg, 5'b0} : 16'b0;
wire [15:0] pp6 = b_reg[6] ? {2'b0, a_reg, 6'b0} : 16'b0;
wire [15:0] pp7 = b_reg[7] ? {1'b0, a_reg, 7'b0} : 16'b0;

// Pipeline registers
reg [15:0] sum0, sum1;
reg en_delay;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset only essential registers
        a_reg <= 8'b0;
        b_reg <= 8'b0;
        en_reg <= 1'b0;
        sum0 <= 16'b0;
        sum1 <= 16'b0;
        en_delay <= 1'b0;
        mul_out <= 16'b0;
        mul_en_out <= 1'b0;
    end
    else begin
        // Input stage
        en_reg <= mul_en_in;
        if (mul_en_in) begin
            a_reg <= mul_a;
            b_reg <= mul_b;
        end

        // First addition stage (parallel adds)
        sum0 <= pp0 + pp1 + pp2 + pp3;
        sum1 <= pp4 + pp5 + pp6 + pp7;
        en_delay <= en_reg;

        // Output stage (final sum)
        mul_en_out <= en_delay;
        mul_out <= sum0 + sum1;
    end
end

endmodule