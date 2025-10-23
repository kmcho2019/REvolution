module TopModule (
    input clk,
    input areset,
    input [7:0] d,
    output reg [7:0] q
);

// 8-bit register with asynchronous active-high reset
// PPA Optimizations:
// - Single always block minimizes control logic
// - Vector operations reduce routing complexity
// - Shared reset signal minimizes fanout
always @(posedge clk or posedge areset) begin
    if (areset) begin
        q <= 8'b0;  // Asynchronous reset clears all bits
    end
    else begin
        q <= d;     // Parallel capture on rising clock edge
    end
end

endmodule