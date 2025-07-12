module multi_pipe_4bit (
    input clk,  // clock signal
    input rst_n,  // active-low reset signal
    input [3:0] mul_a,  // input signal representing the multiplicand
    input [3:0] mul_b,  // input signal representing the multiplier
    output reg [7:0] mul_out  // product output signal
);

// define the size of the multiplier and multiplicand
parameter size = 4;

// generate the partial products for each bit position of the multiplier
reg [7:0] sum_reg1;
reg [7:0] sum_reg2;

// calculate the partial products and update the registers
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_reg1 <= 8'd0;
        sum_reg2 <= 8'd0;
        mul_out <= 8'd0;
    end else begin
        sum_reg1 <= (mul_b[0] ? (mul_a << 0) : 8'd0) + (mul_b[1] ? (mul_a << 1) : 8'd0);
        sum_reg2 <= (mul_b[2] ? (mul_a << 2) : 8'd0) + (mul_b[3] ? (mul_a << 3) : 8'd0);
        mul_out <= sum_reg1 + sum_reg2;
    end
end

endmodule