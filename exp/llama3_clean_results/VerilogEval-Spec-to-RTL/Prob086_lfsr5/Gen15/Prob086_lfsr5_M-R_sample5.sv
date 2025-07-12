module TopModule(
    input clk,
    input reset,
    output reg [4:0] q
);

// Internal wires for the next state calculation
wire next_q0;
wire [4:1] next_q_high;

// Calculate the next state of q[0] based on the taps
assign next_q0 = q[4] ^ q[2];

// Shift the higher bits to the right
assign next_q_high = q[3:0];

// Update q on the positive clock edge
always @(posedge clk) begin
    if (reset) begin
        q <= 5'b10000; // Reset the LFSR to a known state
    end else begin
        // Update q based on the calculated next state
        q <= {next_q_high, next_q0};
    end
end

endmodule