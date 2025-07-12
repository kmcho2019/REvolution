module multi_pipe_4bit (
    input clk,  // clock signal
    input rst_n,  // active-low reset signal
    input [3:0] mul_a,  // input signal representing the multiplicand
    input [3:0] mul_b,  // input signal representing the multiplier
    output reg [7:0] mul_out  // product output signal
);

// define the size of the multiplier and multiplicand
parameter size = 4;

// calculate partial products based on multiplier bits
wire [7:0] partial_product0 = (mul_b[0] == 1'b1) ? {4'b0, mul_a} : 8'd0;
wire [7:0] partial_product1 = (mul_b[1] == 1'b1) ? {4'b0, mul_a} << 1 : 8'd0;
wire [7:0] partial_product2 = (mul_b[2] == 1'b1) ? {4'b0, mul_a} << 2 : 8'd0;
wire [7:0] partial_product3 = (mul_b[3] == 1'b1) ? {4'b0, mul_a} << 3 : 8'd0;

// registers to store intermediate sum
reg [7:0] sum1, sum2, final_sum;

// single always block to update registers
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum1 <= 8'd0;
        sum2 <= 8'd0;
        final_sum <= 8'd0;
        mul_out <= 8'd0;
    end else begin
        // calculate sum1
        sum1 <= partial_product0 + partial_product1;
        
        // calculate sum2
        sum2 <= partial_product2 + partial_product3;
        
        // calculate final sum
        final_sum <= sum1 + sum2;
        
        // update output
        mul_out <= final_sum;
    end
end

endmodule