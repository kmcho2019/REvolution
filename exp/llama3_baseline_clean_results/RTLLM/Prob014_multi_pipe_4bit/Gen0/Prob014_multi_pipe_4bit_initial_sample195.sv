module multi_pipe_4bit(
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output [7:0] mul_out
);

// Define size parameter
parameter size = 4;

// Extend input signals by adding "size" number of zero bits at the most significant bit positions
wire [7:0] mul_a_ext = {4'd0, mul_a};
wire [7:0] mul_b_ext = {4'd0, mul_b};

// Generate block to perform multiplication for each bit position of the multiplier
wire [7:0] partial_products [3:0];
genvar i;
generate
    for (i = 0; i < size; i = i + 1) begin
        assign partial_products[i] = (mul_b_ext[i] == 1'd1) ? (mul_a_ext << i) : 8'd0;
    end
endgenerate

// Registers to store intermediate sum values
reg [7:0] sum1;
reg [7:0] sum2;
reg [7:0] mul_out_reg;

// Add operations on the positive edge of the clock signal or the falling edge of the reset signal
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        sum1 <= 8'd0;
        sum2 <= 8'd0;
        mul_out_reg <= 8'd0;
    end else begin
        sum1 <= partial_products[0] + partial_products[1];
        sum2 <= partial_products[2] + partial_products[3];
        mul_out_reg <= sum1 + sum2;
    end
end

// Assign output
assign mul_out = mul_out_reg;

endmodule