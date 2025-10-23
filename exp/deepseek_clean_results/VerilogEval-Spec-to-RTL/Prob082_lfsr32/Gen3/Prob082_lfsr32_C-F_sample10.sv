module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

// Precomputed tap mask (bits 31,21,1,0 in 0-based indexing)
localparam TAP_MASK = 32'h80040003;

always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1;
    end
    else begin
        // Efficient Galois LFSR implementation:
        // 1. Right shift all bits
        // 2. XOR tapped bits with feedback (q[0])
        q <= {1'b0, q[31:1]} ^ (TAP_MASK & {32{q[0]}});
    end
end

endmodule