module ring_counter (
    input clk,
    input reset,
    output reg [7:0] out
);

// One-hot encoded state register
reg [7:0] q;

// Configurable initial state (LSB set by default)
parameter INIT_STATE = 8'b00000001;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        q <= INIT_STATE;  // Reset to initial state
    end
    else begin
        // Shift left with circular wrap-around
        q <= {q[6:0], q[7]};
    end
end

// Continuous assignment for output
assign out = q;

endmodule