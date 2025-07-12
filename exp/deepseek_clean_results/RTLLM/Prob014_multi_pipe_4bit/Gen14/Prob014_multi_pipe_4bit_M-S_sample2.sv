module multi_pipe_4bit #(parameter size = 4) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

reg [2*size-1:0] accum;
wire [2*size-1:0] ext_a = { {size{1'b0}}, mul_a };

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        accum <= 0;
        mul_out <= 0;
    end else begin
        // First cycle: calculate bits 0-1
        accum <= (mul_b[0] ? ext_a : 0) + 
                (mul_b[1] ? ext_a << 1 : 0);
        
        // Second cycle: add bits 2-3 and output
        mul_out <= accum + 
                  (mul_b[2] ? ext_a << 2 : 0) + 
                  (mul_b[3] ? ext_a << 3 : 0);
    end
end

endmodule