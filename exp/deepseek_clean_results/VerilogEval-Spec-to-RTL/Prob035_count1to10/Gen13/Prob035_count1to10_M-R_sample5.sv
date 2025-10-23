module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

// Counter parameters
parameter START = 4'b0001;  // Starting value (1)
parameter END   = 4'b1010;  // Ending value (10)

// Next state logic
wire [3:0] next_state;

assign next_state = reset ? START :         // Reset condition
                   (q[3] & q[1]) ? START : // Optimized check for 10 (1010)
                   q + 4'b0001;            // Normal increment

// Sequential logic
always @(posedge clk) begin
    q <= next_state;
end

endmodule