module multi_pipe_4bit (
    input clk,  // clock signal
    input rst_n,  // active-low reset signal
    input [3:0] mul_a,  // input signal representing the multiplicand
    input [3:0] mul_b,  // input signal representing the multiplier
    output reg [7:0] mul_out  // product output signal
);

// define the size of the multiplier and multiplicand
parameter size = 4;

// calculate the partial products in parallel
reg [7:0] partial_product [3:0];

// generate the partial products
genvar i;
generate
    for (i = 0; i < size; i++) begin
        if (i == 0) begin
            assign partial_product[i] = mul_b[i] ? {4'b0, mul_a} : 8'd0;
        end else begin
            assign partial_product[i] = mul_b[i] ? {4'b0, mul_a} << i : 8'd0;
        end
    end
endgenerate

// sum up the partial products using a tree of adders
reg [7:0] sum1;
reg [7:0] sum2;
reg [7:0] sum3;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum1 <= 8'd0;
        sum2 <= 8'd0;
        sum3 <= 8'd0;
        mul_out <= 8'd0;
    end else begin
        sum1 <= partial_product[0] + partial_product[1];
        sum2 <= partial_product[2] + partial_product[3];
        sum3 <= sum1 + sum2;
        mul_out <= sum3;
    end
end

endmodule