module TopModule (
    input        clk,
    input        reset,
    output reg [4:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 5'b00001;  // synchronous reset to non-zero state
    end else begin
        // Implement Galois LFSR with taps at bits 5 (q[4]) and 3 (q[2])
        // Feedback is implicitly q[0], taps XOR feedback
        q[0] <= q[1];
        q[1] <= q[2];
        q[2] <= q[3] ^ q[0];
        q[3] <= q[4];
        q[4] <= q[0];
    end
end

endmodule