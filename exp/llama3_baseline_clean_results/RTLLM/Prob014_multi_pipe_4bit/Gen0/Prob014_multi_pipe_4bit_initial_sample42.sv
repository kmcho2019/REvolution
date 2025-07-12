module multi_pipe_4bit (
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output reg [7:0] mul_out
);

reg [7:0] partial_products [3:0];
reg [7:0] sum_reg1, sum_reg2;

// Extension of input signals
wire [7:0] mul_a_ext = {4'b0000, mul_a};
wire [7:0] mul_b_ext = {4'b0000, mul_b};

// Generate block to perform multiplication for each bit position of the multiplier (mul_b)
genvar i;
generate
    for (i = 0; i < 4; i++) begin
        assign partial_products[i] = (mul_b_ext[i]) ? (mul_a_ext << i) : 8'd0;
    end
endgenerate

// Add of partial products
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        sum_reg1 <= 8'd0;
    end else begin
        sum_reg1 <= partial_products[0] + partial_products[1] + partial_products[2] + partial_products[3];
    end
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        sum_reg2 <= 8'd0;
    end else begin
        sum_reg2 <= sum_reg1;
    end
end

// Final product calculation
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_out <= 8'd0;
    end else begin
        mul_out <= sum_reg2;
    end
end

endmodule