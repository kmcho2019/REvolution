module pe (
    input clk,  // Clock signal
    input rst,  // Reset signal
    input [31:0] a,  // Input operand A
    input [31:0] b,  // Input operand B
    output [31:0] c  // Accumulated result
);

reg [31:0] c;  // Register to store the accumulated result

// Sequential logic for multiplication and accumulation
always @(posedge clk) begin
    if (rst) begin
        c <= 32'd0;
    end else begin
        c <= c + (a * b);
    end
end

endmodule