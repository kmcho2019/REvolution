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
        // Handle taps (positions 32,22,2,1 in 1-based)
        q[31] <= q[31] ^ q[0];  // Position 32 (bit 31)
        q[21] <= q[21] ^ q[0];   // Position 22 (bit 21)
        q[1]  <= q[1]  ^ q[0];   // Position 2 (bit 1)
        q[0]  <= q[0]  ^ q[0];   // Position 1 (bit 0) - equivalent to 0
        
        // Handle non-tap positions (simple right shift)
        q[30:22] <= q[31:23];
        q[20:2]  <= q[21:3];
    end
end

endmodule