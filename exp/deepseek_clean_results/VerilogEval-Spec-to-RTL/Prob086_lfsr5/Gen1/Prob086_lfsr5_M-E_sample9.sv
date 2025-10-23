module TopModule (
    input clk,
    input reset,
    output reg [4:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 5'b00001;
    end else begin
        // Calculate each bit separately for clarity
        q[4] <= q[3] ^ q[0];  // Tap at position 5 (bit 4)
        q[3] <= q[2];
        q[2] <= q[1] ^ q[0];  // Tap at position 3 (bit 2)
        q[1] <= q[0];
        q[0] <= q[4];         // Shift the old MSB to LSB
    end
end

endmodule