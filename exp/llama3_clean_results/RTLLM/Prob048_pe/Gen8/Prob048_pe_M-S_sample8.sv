module pe (
    input clk,  // Clock signal
    input rst,  // Reset signal
    input [31:0] a,  // Input operand A
    input [31:0] b,  // Input operand B
    output [31:0] c  // Accumulated result
);

reg [31:0] c;  // Register to store the accumulated result

always @(posedge clk or posedge rst) begin
    if (rst) begin
        // Reset the register when reset signal is high
        c <= 32'd0;
    end else begin
        // Accumulate the result in the register
        c <= c + (a * b);
    end
end

endmodule