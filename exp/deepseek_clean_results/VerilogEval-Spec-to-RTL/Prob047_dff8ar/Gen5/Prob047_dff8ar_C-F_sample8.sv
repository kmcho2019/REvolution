module TopModule (
    input clk,
    input areset,
    input [7:0] d,
    output reg [7:0] q
);

// 8-bit register with asynchronous reset
// All bits reset to 0 when areset is high
// Captures input on rising clock edge when not in reset
always @(posedge clk or posedge areset) begin
    if (areset) begin
        q <= 8'b0;  // Async reset clears all bits
    end
    else begin
        q <= d;      // Capture input on clock edge
    end
end

endmodule