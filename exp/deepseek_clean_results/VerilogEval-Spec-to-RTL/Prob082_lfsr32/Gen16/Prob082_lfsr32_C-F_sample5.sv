module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

// Tap positions: bits 31,21,1,0 (1-based: 32,22,2,1)
wire [31:0] next_q;

assign next_q = reset ? 32'h1 : {
    q[0],                // New MSB is old LSB
    q[31:22],            // Untapped upper bits
    q[21] ^ q[0],        // Tap at bit 21 (1-based 22)
    q[20:2],             // Untapped middle bits
    q[1] ^ q[0],         // Tap at bit 1 (1-based 2)
    q[0] ^ q[0]          // Tap at bit 0 (1-based 1) - simplifies to 0
};

always @(posedge clk) begin
    q <= next_q;
end

endmodule