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
wire [3:0] mul_b_ext = mul_b;

// generate the partial products for each bit position of the multiplier
reg [7:0] partial_product [3:0];

// calculate the partial products
always @(*) begin
    for (int i = 0; i < size; i++) begin
        if (mul_b_ext[i] == 1'b1) begin
            partial_product[i] = {4'b0, mul_a} << i;
        end else begin
            partial_product[i] = 8'd0;
        end
    end
end

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
        sum_reg1 <= partial_product[0] + partial_product[1];
        sum_reg2 <= partial_product[2] + partial_product[3];
        mul_out <= sum_reg1 + sum_reg2;
    end
end

endmodule