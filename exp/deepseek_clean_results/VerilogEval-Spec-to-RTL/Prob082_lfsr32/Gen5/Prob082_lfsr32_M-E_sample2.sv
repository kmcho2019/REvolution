module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1;
    end
    else begin
        // Galois LFSR with taps at positions 32, 22, 2, 1 (1-based)
        q <= {
            q[31] ^ q[0],    // Bit 32 (0-based 31) tapped
            q[30:22],
            q[21] ^ q[0],    // Bit 22 (0-based 21) tapped
            q[20:2],
            q[1] ^ q[0],     // Bit 2 (0-based 1) tapped
            q[0] ^ q[0]      // Bit 1 (0-based 0) tapped (effectively zero)
        };
    end
end

endmodule