module TopModule (
    input clk,
    input reset,
    output reg [4:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 5'b00001;  // Reset to 1
    end
    else begin
        // Correct Galois LFSR implementation for polynomial x^5 + x^3 + 1
        q <= {
            q[0] ^ q[4],        // New q[4] (position 5)
            q[3],
            q[0] ^ q[2],        // New q[2] (position 3)
            q[1],
            q[0]                // Shift out LSB
        };
    end
end

endmodule