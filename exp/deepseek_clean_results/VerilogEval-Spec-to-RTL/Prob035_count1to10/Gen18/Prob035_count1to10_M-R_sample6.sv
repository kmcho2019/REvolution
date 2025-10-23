module TopModule (
    input clk,
    input reset,
    output [3:0] q
);

// Counter parameters
parameter START = 4'b0001;  // Starting value (1)

// Feedback register implementation
reg [3:0] q_reg;
wire [3:0] next_state;

// Next state logic
assign next_state = reset ? START :         // Reset condition
                   (q_reg == 4'b1010) ? START :  // Check for 10
                   q_reg + 4'b0001;        // Normal increment

// Register update
always @(posedge clk) begin
    q_reg <= next_state;
end

// Output assignment
assign q = q_reg;

endmodule