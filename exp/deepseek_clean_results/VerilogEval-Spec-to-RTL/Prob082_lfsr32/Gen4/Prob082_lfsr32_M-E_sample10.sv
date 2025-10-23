module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

// Tap positions mask (bits 31,21,1,0 correspond to positions 32,22,2,1)
parameter [31:0] TAP_MASK = 32'b10000000001000000000000000000011;

always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1;
    end
    else begin
        // Parallel computation of all XOR taps
        q <= {q[0], q[31:1]} ^ (TAP_MASK & {32{q[0]}});
    end
end

endmodule