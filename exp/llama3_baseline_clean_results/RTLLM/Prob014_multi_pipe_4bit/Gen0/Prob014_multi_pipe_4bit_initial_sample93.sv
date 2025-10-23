module multi_pipe_4bit(
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output [7:0] mul_out
);

// Define registers to store intermediate values
reg [7:0] partial_product;
reg [7:0] sum_reg1;
reg [7:0] sum_reg2;

// Extend input signals by adding 4 zero bits at the most significant bit positions
wire [7:0] mul_a_ext = {4'd0, mul_a};
wire [7:0] mul_b_ext = {4'd0, mul_b};

// Generate block to perform multiplication for each bit position of the multiplier
genvar i;
generate
    for (i = 0; i < 4; i = i + 1) begin
        // Calculate partial product
        wire [7:0] partial_product_i = (mul_b_ext[i] == 1'd1) ? (mul_a_ext << i) : 8'd0;
        
        // Add partial product to sum
        if (i == 0) begin
            assign partial_product = partial_product_i;
        end else begin
            assign partial_product = partial_product + partial_product_i;
        end
    end
endgenerate

// Update sum registers on positive edge of clock or falling edge of reset
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        sum_reg1 <= 8'd0;
        sum_reg2 <= 8'd0;
    end else begin
        sum_reg1 <= partial_product;
        sum_reg2 <= sum_reg1;
    end
end

// Calculate final product on positive edge of clock or falling edge of reset
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_out <= 8'd0;
    end else begin
        mul_out <= sum_reg2;
    end
end

endmodule