module multi_pipe_4bit #(
    parameter size = 4
) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

// Extended multiplicand
wire [2*size-1:0] ext_a = {{size{1'b0}}, mul_a};

// Pipeline Stage 1: Input registration and partial product generation
reg [size-1:0] a_reg, b_reg;
wire [2*size-1:0] pp0, pp1, pp2, pp3;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        a_reg <= '0;
        b_reg <= '0;
    end else begin
        a_reg <= mul_a;
        b_reg <= mul_b;
    end
end

// Partial products (combinational)
assign pp0 = b_reg[0] ? ext_a : '0;
assign pp1 = b_reg[1] ? (ext_a << 1) : '0;
assign pp2 = b_reg[2] ? (ext_a << 2) : '0;
assign pp3 = b_reg[3] ? (ext_a << 3) : '0;

// Pipeline Stage 2: Intermediate sum registration
reg [2*size-1:0] sum_lo, sum_hi;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_lo <= '0;
        sum_hi <= '0;
    end else begin
        sum_lo <= pp0 + pp1;  // First adder stage
        sum_hi <= pp2 + pp3;  // First adder stage
    end
end

// Pipeline Stage 3: Final sum registration
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_out <= '0;
    end else begin
        mul_out <= sum_lo + sum_hi;  // Second adder stage
    end
end

endmodule