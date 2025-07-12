module TopModule #(
    parameter WIDTH = 8
) (
    input clk,
    input areset,
    input [WIDTH-1:0] d,
    output reg [WIDTH-1:0] q
);

// Parameterized register with asynchronous reset
// All bits reset to 0 when areset is high
// Captures input on rising clock edge when not in reset
always @(posedge clk or posedge areset) begin
    if (areset) begin
        q <= {WIDTH{1'b0}};  // Async reset clears all bits
    end
    else begin
        q <= d;               // Capture input on clock edge
    end
end

endmodule