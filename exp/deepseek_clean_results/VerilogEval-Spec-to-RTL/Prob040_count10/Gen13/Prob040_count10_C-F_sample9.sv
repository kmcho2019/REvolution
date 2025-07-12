module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

wire [3:0] next_q;

// Optimized combinational next state logic
assign next_q = reset ? 4'b0000 :       // Synchronous reset
                (q == 4'b1001) ? 4'b0000 :  // Explicit check for 9 (1001)
                q + 1'b1;                 // Normal increment

// Sequential state update
always @(posedge clk) begin
    q <= next_q;
end

endmodule