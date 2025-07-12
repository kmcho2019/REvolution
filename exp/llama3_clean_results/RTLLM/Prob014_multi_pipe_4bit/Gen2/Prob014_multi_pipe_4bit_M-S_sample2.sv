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

// use registers to store the intermediate sum values
reg [7:0] partial_product0;
reg [7:0] partial_product1;
reg [7:0] partial_product2;
reg [7:0] partial_product3;

// update the registers with the partial products
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        partial_product0 <= 8'd0;
        partial_product1 <= 8'd0;
        partial_product2 <= 8'd0;
        partial_product3 <= 8'd0;
        mul_out <= 8'd0;
    end else begin
        partial_product0 <= (mul_b[0] == 1'b1)? {4'b0, mul_a} : 8'd0;
        partial_product1 <= (mul_b[1] == 1'b1)? {4'b0, mul_a} << 1 : 8'd0;
        partial_product2 <= (mul_b[2] == 1'b1)? {4'b0, mul_a} << 2 : 8'd0;
        partial_product3 <= (mul_b[3] == 1'b1)? {4'b0, mul_a} << 3 : 8'd0;
        mul_out <= partial_product0 + partial_product1 + partial_product2 + partial_product3;
    end
end

endmodule