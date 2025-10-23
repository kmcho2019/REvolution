module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1;
    end else begin
        q <= {q[0],                // Bit 32 (tap)
              q[31:23],            // Untapped upper bits
              q[22] ^ q[0],        // Bit 22 (tap)
              q[21:3],             // Middle untapped bits
              q[2] ^ q[0],         // Bit 2 (tap)
              q[1] ^ q[0]};        // Bit 1 (tap)
    end
end

endmodule