module TopModule(
    input clk,
    input reset,
    output reg [4:0] q
);

// Define the next state of each bit position
reg [4:0] next_q;

always @(*) begin
    // Compute the next state of each bit position
    next_q[4] = q[3] ^ q[0]; // Tap at position 5 (index 4)
    next_q[3] = q[2] ^ q[0]; // Tap at position 3
    next_q[2] = q[1];
    next_q[1] = q[0];
    next_q[0] = q[4];
end

// Update the state on the positive edge of the clock
always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Reset the LFSR output to a non-zero value
        q <= 5'b1; // Set the LSB to 1
    end else begin
        // Update the state
        q <= next_q;
    end
end

endmodule