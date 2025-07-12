module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

wire [3:0] next_q;

// Combinational logic for next state
assign next_q = (reset) ? 4'b0001 :       // Reset condition
                (q[3] & q[1]) ? 4'b0001 : // Wrap around at 10
                q + 4'b0001;              // Normal increment

// Sequential logic for state update
always @(posedge clk) begin
    q <= next_q;
end

endmodule