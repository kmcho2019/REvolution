module multi_pipe_4bit (
    input clk,  // clock signal
    input rst_n,  // active-low reset signal
    input [3:0] mul_a,  // input signal representing the multiplicand
    input [3:0] mul_b,  // input signal representing the multiplier
    output reg [7:0] mul_out  // product output signal
);

// define the size of the multiplier and multiplicand
parameter size = 4;

// extend the input signals by adding "size" number of zero bits
reg [7:0] mul_a_ext;
reg [7:0] mul_b_ext;

// calculate the partial products and add them together
reg [7:0] sum_reg1;
reg [7:0] sum_reg2;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_a_ext <= 8'd0;
        mul_b_ext <= 8'd0;
        sum_reg1 <= 8'd0;
        sum_reg2 <= 8'd0;
        mul_out <= 8'd0;
    end else begin
        mul_a_ext <= {4'd0, mul_a};
        mul_b_ext <= {4'd0, mul_b};
        sum_reg1 <= (mul_b_ext[0] ? mul_a_ext : 8'd0) + (mul_b_ext[1] ? (mul_a_ext << 1) : 8'd0);
        sum_reg2 <= sum_reg1 + (mul_b_ext[2] ? (mul_a_ext << 2) : 8'd0) + (mul_b_ext[3] ? (mul_a_ext << 3) : 8'd0);
        mul_out <= sum_reg2;
    end
end

endmodule