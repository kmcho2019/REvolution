module TopModule(
    input clk,
    input reset,
    output reg [4:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 5'b00001; // Reset the LFSR to the specified initial state
    end else begin
        // Shift the LFSR state right, applying the taps directly
        q[4] <= q[3];
        q[3] <= q[2];
        q[2] <= q[1];
        q[1] <= q[0];
        // Calculate the new least significant bit (LSB) using the taps
        q[0] <= q[4] ^ q[2];
    end
end

endmodule