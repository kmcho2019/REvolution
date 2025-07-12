module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    // Tap mask for taps at bit positions 32,22,2,1 (1-based),
    // which correspond to 0-based bits 31,21,1,0
    localparam [31:0] TAP_MASK = (1 << 31) | (1 << 21) | (1 << 1) | (1 << 0);

    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            // feedback is the LSB of q
            wire feedback = q[0];

            // shift q right by 1 bit; MSB filled later
            // XOR tapped bits with feedback (if feedback=1, flip taps)
            // MSB becomes feedback
            q <= {feedback, (q >> 1) ^ (TAP_MASK & {32{feedback}})};
        end
    end

endmodule