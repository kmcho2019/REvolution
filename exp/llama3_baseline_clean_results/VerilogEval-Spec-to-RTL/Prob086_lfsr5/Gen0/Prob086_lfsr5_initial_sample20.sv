module TopModule(
    input clk,
    input reset,
    output reg [4:0] q
);

always @(posedge clk) begin
    if (reset) begin
        // Reset the LFSR output to 1
        q <= 5'b00001;
    end else begin
        // Calculate the next state of the LFSR
        q[4] <= q[3] ^ q[0];  // Tap at position 5 (MSB)
        q[3] <= q[2] ^ q[0];  // Tap at position 3
        q[2] <= q[1];
        q[1] <= q[0];
        q[0] <= 0;  // Shift in a 0 at the LSB
    end
end

endmodule