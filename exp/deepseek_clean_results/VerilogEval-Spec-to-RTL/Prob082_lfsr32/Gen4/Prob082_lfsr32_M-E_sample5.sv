module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

// Tap mask for positions 32, 22, 2, and 1 (note: bit 31 is position 32 in 0-based indexing)
localparam TAP_MASK = 32'b11000000000000000000010000000011;

always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1;
    end
    else begin
        // Calculate feedback (LSB)
        // Apply XOR with feedback to all tap positions in parallel
        // Then shift right and insert feedback at MSB
        q <= {q[0], q[31:1]} ^ (TAP_MASK & {32{q[0]}});
    end
end

endmodule