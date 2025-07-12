module multi_pipe_4bit(
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output reg [7:0] mul_out
);

localparam size = 4;

// Extend input signals by adding "size" number of zero bits at the most significant bit positions
wire [7:0] a_ext = {4'd0, mul_a};
wire [7:0] b_ext = {4'd0, mul_b};

// Generate partial products for each bit position of the multiplier
reg [7:0] partial_products [3:0];
reg [7:0] sum1;
reg [7:0] sum2;

integer i;
always @(*) begin
    for (i = 0; i < size; i++) begin
        if (b_ext[i] == 1'b1) begin
            partial_products[i] = a_ext << i;
        end else begin
            partial_products[i] = 8'd0;
        end
    end
end

// Add partial products and store in registers
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        sum1 <= 8'd0;
        sum2 <= 8'd0;
    end else begin
        sum1 <= partial_products[0] + partial_products[1];
        sum2 <= partial_products[2] + partial_products[3];
    end
end

// Calculate final product and update product output
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_out <= 8'd0;
    end else begin
        mul_out <= sum1 + sum2;
    end
end

endmodule