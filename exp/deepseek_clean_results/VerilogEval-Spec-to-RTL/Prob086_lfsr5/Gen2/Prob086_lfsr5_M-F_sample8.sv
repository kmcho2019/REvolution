module TopModule (
    input clk,
    input reset,
    output reg [4:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 5'b00001;
    end else begin
        // Galois LFSR with taps at positions 5 and 3 (1-based)
        q[4] <= q[4] ^ q[0];  // Tap at position 5 (0-based: 4)
        q[3] <= q[4];          // Regular shift
        q[2] <= q[3] ^ q[0];  // Tap at position 3 (0-based: 2)
        q[1] <= q[2];          // Regular shift
        q[0] <= q[1];         // Regular shift
    end
end

endmodule