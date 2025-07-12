module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    // Tap mask for positions 32, 22, 2, and 1 (0-based: 31,21,1,0)
    // Bits with taps are set to 1 in the mask
    localparam [31:0] TAP_MASK = (1 << 31) | (1 << 21) | (1 << 1) | (1 << 0);

    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            // Galois LFSR step:
            // If feedback (q[0]) is 1, next state = (q >> 1) XOR tap mask
            // else next state = q >> 1
            if (q[0]) begin
                q <= (q >> 1) ^ TAP_MASK;
            end else begin
                q <= q >> 1;
            end
        end
    end

endmodule