module TopModule(
    input clk,
    input reset,
    output reg [4:0] q
);

always @(posedge clk) begin
    if (reset)
        q <= 5'b00001;
    else begin
        wire fb = q[0];
        q <= { (q[4] ^ fb), (q[3]), (q[2] ^ fb), (q[1]), (q[0]) };
        // Explanation of assignment:
        // q[4] <= q[4] ^ fb (tap)
        // q[3] <= q[3] (no tap)
        // q[2] <= q[2] ^ fb (tap)
        // q[1] <= q[1] (no tap)
        // q[0] <= q[0] (will be replaced by q[1] shift below)
        // But since LFSR shifts right, positions must reflect shifted inputs.
        // Correct shift right: q[4] gets (q[3] ^ fb), q[3] <= q[2], q[2] <= (q[1] ^ fb), etc.
        // So re-assign with correct shift:
        // q[4] <= q[3] ^ fb
        // q[3] <= q[2]
        // q[2] <= q[1] ^ fb
        // q[1] <= q[0]
        // q[0] <= fb (feedback bit)

        // Update with corrected logic:
        q <= { (q[3] ^ fb), q[2], (q[1] ^ fb), q[0], fb };
    end
end

endmodule