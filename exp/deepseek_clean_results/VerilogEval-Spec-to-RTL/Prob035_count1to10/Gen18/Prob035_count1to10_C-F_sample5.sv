module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

// Counter parameters
parameter START = 4'b0001;  // Starting value (1)
// Note: q[3]&q[1] detects 10 (1010) more efficiently than full comparison

// Next state logic
wire [3:0] next_state;

assign next_state = reset ? START :         // Highest priority: synchronous reset
                   (q[3] & q[1]) ? START : // Efficient wrap detection (1010)
                   q + 4'b0001;            // Normal increment

// Sequential logic
always @(posedge clk) begin
    q <= next_state;
end

endmodule