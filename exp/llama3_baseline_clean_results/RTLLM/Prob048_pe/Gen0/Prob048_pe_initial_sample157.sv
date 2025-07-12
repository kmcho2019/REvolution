module pe(
    input clk,        // Clock signal
    input rst,        // Reset signal
    input [31:0] a,   // 32-bit input operand A
    input [31:0] b,   // 32-bit input operand B
    output reg [31:0] c // 32-bit output representing the accumulated result
);

always @ (posedge clk or posedge rst) begin
    if (rst) begin
        // Reset the accumulator to 0 when reset signal is high
        c <= 32'd0;
    end else begin
        // Multiply a and b, and accumulate the result into c
        c <= c + (a * b);
    end
end

endmodule