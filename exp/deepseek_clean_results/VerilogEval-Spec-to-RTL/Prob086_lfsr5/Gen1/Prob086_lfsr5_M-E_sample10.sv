module TopModule (
    input clk,
    input reset,
    output reg [4:0] q
);

wire feedback;
wire [4:0] next_state;

assign feedback = q[0];  // LSB is the feedback bit

// Compute next state:
// MSB comes from feedback XOR with current MSB (tap position 5)
// Other tapped bits get XORed with feedback
// Untapped bits simply shift right
assign next_state = {
    feedback ^ q[4],  // New MSB (tap position 5)
    q[4],             // Shift right
    q[3],             // Shift right
    feedback ^ q[2],   // Tap position 3
    q[1]              // Shift right
};

always @(posedge clk) begin
    if (reset) begin
        q <= 5'b00001;  // Active-high synchronous reset to 1
    end else begin
        q <= next_state;
    end
end

endmodule