module multi_pipe_4bit #(
    parameter size = 4
)(
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

reg [size-1:0] multiplicand_reg;
reg [size-1:0] multiplier_reg;
reg [2*size-1:0] partial_sum_reg;

// Input stage
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        multiplicand_reg <= {size{1'b0}};
        multiplier_reg <= {size{1'b0}};
        partial_sum_reg <= {2*size{1'b0}};
        mul_out <= {2*size{1'b0}};
    end else begin
        multiplicand_reg <= mul_a;
        multiplier_reg <= mul_b;
    end
end

// Partial product generation and accumulation stage
wire [2*size-1:0] partial_sum;
assign partial_sum = {2*size{1'b0}};
for (genvar i = 0; i < size; i++) begin
    if (multiplier_reg[i] == 1'b1) begin
        assign partial_sum = partial_sum + ({size{1'b0}, multiplicand_reg} << i);
    end
end

// Output stage
always @(posedge clk) begin
    partial_sum_reg <= partial_sum;
    mul_out <= partial_sum_reg;
end

endmodule