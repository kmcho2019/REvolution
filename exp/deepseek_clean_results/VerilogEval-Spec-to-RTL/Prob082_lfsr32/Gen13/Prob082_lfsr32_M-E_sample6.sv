module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

// Tap mask for positions 32,22,2,1 (bit 31 is position 32 in 1-based indexing)
parameter TAP_MASK = 32'h80000043;

always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1;
    end else begin
        // Parallel computation: XOR tap positions with LSB
        q <= {q[30:0], 1'b0} ^ ({32{q[0]}} & TAP_MASK);
    end
end

endmodule