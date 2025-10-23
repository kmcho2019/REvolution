module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

wire [3:0] next_q;

// Combinational next state logic
assign next_q = (reset)       ? 4'b0001 :    // Reset has highest priority
                (q == 4'b1010) ? 4'b0001 :   // Wrap around at 10 (1010)
                q + 4'b0001;                // Otherwise increment

// Sequential state update
always @(posedge clk) begin
    q <= next_q;
end

endmodule