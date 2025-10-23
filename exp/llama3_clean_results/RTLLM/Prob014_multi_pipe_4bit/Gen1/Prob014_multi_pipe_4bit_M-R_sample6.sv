module multi_pipe_4bit (
    input clk,  // clock signal
    input rst_n,  // active-low reset signal
    input [3:0] mul_a,  // input signal representing the multiplicand
    input [3:0] mul_b,  // input signal representing the multiplier
    output reg [7:0] mul_out  // product output signal
);

// define the size of the multiplier and multiplicand
parameter size = 4;

// extend the input signals by adding "size" number of zero bits at the most significant bit positions
wire [7:0] mul_a_ext = {4'b0, mul_a};
wire [7:0] mul_b_ext = {4'b0, mul_b};

// generate the partial products for each bit position of the multiplier
wire [7:0] partial_product_0 = mul_b_ext[0] ? (mul_a_ext << 0) : 8'd0;
wire [7:0] partial_product_1 = mul_b_ext[1] ? (mul_a_ext << 1) : 8'd0;
wire [7:0] partial_product_2 = mul_b_ext[2] ? (mul_a_ext << 2) : 8'd0;
wire [7:0] partial_product_3 = mul_b_ext[3] ? (mul_a_ext << 3) : 8'd0;

// use registers to store the intermediate sum values
reg [7:0] sum_reg1;
reg [7:0] sum_reg2;

// update the registers with the sum of the corresponding partial products
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_reg1 <= 8'd0;
        sum_reg2 <= 8'd0;
        mul_out <= 8'd0;
    end else begin
        sum_reg1 <= partial_product_0 + partial_product_1;
        sum_reg2 <= sum_reg1 + partial_product_2 + partial_product_3;
        mul_out <= sum_reg2;
    end
end

endmodule