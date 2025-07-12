module TopModule(
    input        clk,
    input        reset,
    output reg [4:0] q
);

    wire feedback = q[0];
    wire [4:0] next_q;

    // Construct next state vector with taps at bit positions 5 and 3
    assign next_q = {feedback, q[4:2] ^ {2'b10 & {2{feedback}}}, q[1]};

    // Explanation:
    // q[4] <= feedback (tap at bit 5)
    // q[3] <= q[4] ^ feedback (tap at bit 3)
    // q[2] <= q[3]
    // q[1] <= q[2]
    // q[0] <= q[1]
    // So mapping each bit:
    // next_q[4] = feedback
    // next_q[3] = q[4] ^ feedback (tap 3)
    // next_q[2] = q[3]
    // next_q[1] = q[2]
    // next_q[0] = q[1]
    // To build this compactly:
    // next_q = {feedback, q[4]^feedback, q[3], q[2], q[1]}
    // Because q[4]^feedback and q[3] are taps at bits 5 and 3 respectively.

    // However, feedback is only XORed into taps at bit 5 and 3, so only q[4] and q[2].
    // Since in Galois form, feedback is XORed with q[2] (bit 3 in zero-based) and q[4] (bit 5).
    // Need to correct taps:
    // q[4] <= q[4] ^ feedback;
    // q[3] <= q[4];
    // q[2] <= q[3] ^ feedback;
    // q[1] <= q[2];
    // q[0] <= q[1];
    // So taps are at q[4] and q[2]. So q[4] <= q[4]^feedback, q[2] <= q[3]^feedback.

    // Final corrected logic:
    // next_q[4] = q[4] ^ feedback;
    // next_q[3] = q[4];
    // next_q[2] = q[3] ^ feedback;
    // next_q[1] = q[2];
    // next_q[0] = q[1];

    assign next_q = {
        q[4] ^ feedback,
        q[4],
        q[3] ^ feedback,
        q[2],
        q[1]
    };

    always @(posedge clk) begin
        if (reset)
            q <= 5'b00001;
        else
            q <= next_q;
    end

endmodule