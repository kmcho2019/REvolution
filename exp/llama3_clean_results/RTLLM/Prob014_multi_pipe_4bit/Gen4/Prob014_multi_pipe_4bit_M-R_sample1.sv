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

// first level of registers to store partial products
reg [7:0] reg1;
reg [7:0] reg2;

// first stage of pipeline to add partial products of lower 2 bits
assign reg1 = partial_product0 + partial_product1;

// second stage of pipeline to add partial products of upper 2 bits and result from first stage
assign reg2 = partial_product2 + partial_product3 + reg1;

// second level of registers to store sum of partial products
reg [7:0] sum;

// update sum register on positive edge of clock
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum <= 8'd0;
    end else begin
        sum <= reg2;
    end
end

// update output register on positive edge of clock
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_out <= 8'd0;
    end else begin
        mul_out <= sum;
    end
end

endmodule