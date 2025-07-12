module multi_pipe_4bit (
    input clk,  // clock signal
    input rst_n,  // active-low reset signal
    input [3:0] mul_a,  // input signal representing the multiplicand
    input [3:0] mul_b,  // input signal representing the multiplier
    output reg [7:0] mul_out  // product output signal
);

// define the size of the multiplier and multiplicand
parameter size = 4;

// generate partial products
wire [7:0] partial_products [3:0];
genvar i;
generate
    for (i = 0; i < size; i++) begin
        assign partial_products[i] = (mul_b[i] == 1'b1)? {4'b0, mul_a} << i : 8'd0;
    end
endgenerate

// pipeline stages
reg [7:0] stage1, stage2, stage3, stage4;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage1 <= 8'd0;
        stage2 <= 8'd0;
        stage3 <= 8'd0;
        stage4 <= 8'd0;
        mul_out <= 8'd0;
    end else begin
        stage1 <= partial_products[0] + partial_products[1];
        stage2 <= stage1 + partial_products[2];
        stage3 <= stage2 + partial_products[3];
        stage4 <= stage3;
        mul_out <= stage4;
    end
end

endmodule