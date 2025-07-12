module TopModule(
    input clk,
    input reset,
    output reg [4:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 5'b00001;
    end else begin
        // Compute feedback as XOR of q[0], q[2] (tap bit 3), and q[4] (tap bit 5)
        // But since this is a Galois LFSR, the feedback is just q[0], 
        // and taps modify certain bits by XORing with q[0].
        // Equivalent to:
        // new_q[4] = q[0]
        // new_q[3] = q[4]
        // new_q[2] = q[3] ^ q[0]
        // new_q[1] = q[2]
        // new_q[0] = q[1]
        // Implement this using a single vector assignment:
        q <= {q[0], q[4], q[3] ^ q[0], q[2], q[1]};
    end
end

endmodule