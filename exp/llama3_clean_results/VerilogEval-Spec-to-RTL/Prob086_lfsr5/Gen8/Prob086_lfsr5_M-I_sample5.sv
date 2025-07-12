module TopModule(
    input clk,
    input reset,
    output reg [4:0] q
);

// Update the state on the positive edge of the clock
always @(posedge clk) begin
    if (reset) begin
        // Reset the LFSR output to a non-zero value
        q <= 5'b10000;
    end else begin
        // Update the state based on the next state logic
        q[4] <= q[2] ^ q[0];  // Tap at position 5
        q[3] <= q[1] ^ q[0];  // Tap at position 3
        q[2] <= q[1];
        q[1] <= q[0];
        q[0] <= q[4];        // Shift the MSB to the LSB
    end
end

endmodule