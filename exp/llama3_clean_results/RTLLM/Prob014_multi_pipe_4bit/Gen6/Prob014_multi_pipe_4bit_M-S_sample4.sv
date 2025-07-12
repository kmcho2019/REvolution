module multi_pipe_4bit (
    input clk,  // clock signal
    input rst_n,  // active-low reset signal
    input [3:0] mul_a,  // input signal representing the multiplicand
    input [3:0] mul_b,  // input signal representing the multiplier
    output reg [7:0] mul_out  // product output signal
);

// define the size of the multiplier and multiplicand
parameter size = 4;

// pipeline stages
reg [7:0] stage1;
reg [7:0] stage2;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage1 <= 8'd0;
        stage2 <= 8'd0;
        mul_out <= 8'd0;
    end else begin
        // calculate partial products and their sum
        stage1 <= (mul_b[0]? {4'b0, mul_a} : 8'd0) + 
                  (mul_b[1]? {4'b0, mul_a} << 1 : 8'd0);
        stage2 <= stage1 + (mul_b[2]? {4'b0, mul_a} << 2 : 8'd0) + 
                              (mul_b[3]? {4'b0, mul_a} << 3 : 8'd0);
        mul_out <= stage2;
    end
end

endmodule