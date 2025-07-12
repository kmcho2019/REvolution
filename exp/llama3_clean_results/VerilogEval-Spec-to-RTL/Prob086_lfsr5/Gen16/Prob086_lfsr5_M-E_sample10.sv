module TopModule(
    input clk,
    input reset,
    output [4:0] q
);

// Define the LFSR state
reg [4:0] state;

// Define the LFSR taps
wire tap1;
wire tap2;

// Define the next state logic
always @(posedge clk) begin
    if (reset) begin
        state <= 5'b00001; // Initialize with the correct reset value
    end else begin
        // Calculate the taps
        tap1 <= state[4];
        tap2 <= state[1];

        // Shift the state
        state[4] <= state[3];
        state[3] <= state[2];
        state[2] <= state[1];
        state[1] <= state[0];

        // Apply the taps
        state[0] <= tap1 ^ tap2;
    end
end

assign q = state; // Output the current state of the LFSR

endmodule