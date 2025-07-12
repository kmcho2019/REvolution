module multi_pipe_4bit(
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output reg [7:0] mul_out
);

// Extended input signals by adding 4 zero bits at the most significant bit positions
wire [7:0] a_ext = {4'd0, mul_a};
wire [7:0] b_ext = {4'd0, mul_b};

// Registers to store intermediate values
reg [7:0] partial_product;
reg [7:0] sum_reg1;
reg [7:0] sum_reg2;

// Generate block to perform multiplication for each bit position of the multiplier
integer i;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        partial_product <= 8'd0;
        sum_reg1 <= 8'd0;
        sum_reg2 <= 8'd0;
        mul_out <= 8'd0;
    end else begin
        partial_product <= 8'd0;
        for (i = 0; i < 4; i = i + 1) begin
            if (b_ext[i]) begin
                partial_product <= partial_product + (a_ext << i);
            end
        end
        sum_reg1 <= partial_product;
        sum_reg2 <= sum_reg1;
        mul_out <= sum_reg2;
    end
end

endmodule