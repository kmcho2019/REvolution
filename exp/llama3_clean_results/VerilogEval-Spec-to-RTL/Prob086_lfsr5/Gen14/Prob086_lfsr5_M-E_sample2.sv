module TopModule(
    input clk,
    input reset,
    output [4:0] q
);

reg [4:0] state; // Current state of the LFSR

// Define the tap positions
wire tap_4 = state[4];
wire tap_2 = state[2];

// Calculate the next state of each bit
wire next_state_4 = (reset) ? 1'b1 : (state[3] ^ tap_2);
wire next_state_3 = (reset) ? 1'b0 : state[2];
wire next_state_2 = (reset) ? 1'b0 : state[1];
wire next_state_1 = (reset) ? 1'b0 : state[0];
wire next_state_0 = (reset) ? 1'b0 : (tap_4 ^ tap_2);

// Update the current state of the LFSR
always @(posedge clk) begin
    if (reset) begin
        state <= 5'b10000; // Initialize the LFSR with a non-zero state
    end else begin
        state <= {next_state_4, next_state_3, next_state_2, next_state_1, next_state_0};
    end
end

assign q = state; // Output the current state of the LFSR

endmodule