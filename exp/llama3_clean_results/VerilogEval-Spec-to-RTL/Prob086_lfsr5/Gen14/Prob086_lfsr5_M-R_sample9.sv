module TopModule(
    input clk,
    input reset,
    output reg [4:0] q
);

reg [4:0] nextState;

// Calculate the next state based on the current state and the LFSR polynomial
assign nextState[4] = q[1] ^ q[0]; // Feedback from tap positions
assign nextState[3] = q[4]; // Shift
assign nextState[2] = q[3]; // Shift
assign nextState[1] = q[2]; // Shift
assign nextState[0] = q[1]; // Shift

// Update the state on the positive edge of the clock
always @(posedge clk) begin
    if (reset) begin
        q <= 5'b00001; // Reset the LFSR output to 1
    end else begin
        q <= nextState; // Update the state with the calculated next state
    end
end

endmodule