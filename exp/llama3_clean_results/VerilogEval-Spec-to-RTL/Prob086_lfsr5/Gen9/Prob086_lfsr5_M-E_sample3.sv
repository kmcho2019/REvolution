module TopModule(
    input clk,
    input reset,
    output reg [4:0] q
);

// Update the state on the positive edge of the clock
always @(posedge clk) begin
    if (reset) begin
        // Reset the LFSR output to a non-zero value
        q <= 5'b10001;
    end else begin
        // Update the state based on the next state logic
        reg [4:0] next_state;
        next_state[4] = q[3] ^ q[0];
        next_state[3] = q[2] ^ q[0];
        next_state[2] = q[1];
        next_state[1] = q[0];
        next_state[0] = q[4];
        q <= next_state;
    end
end

endmodule