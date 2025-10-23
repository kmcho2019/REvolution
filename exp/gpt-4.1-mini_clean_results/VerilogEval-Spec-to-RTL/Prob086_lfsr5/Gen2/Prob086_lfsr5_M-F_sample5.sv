module TopModule (
    input         clk,
    input         reset,
    output reg [4:0] q
);

    wire feedback = q[0];
    reg  [4:0] next_q;

    always @(*) begin
        // Calculate next state bits for Galois LFSR with taps at q[4] and q[2]
        next_q[4] = q[4] ^ feedback;  // Tap at bit 5 (q[4])
        next_q[3] = q[4];             // Shift from q[4]
        next_q[2] = q[2] ^ feedback;  // Tap at bit 3 (q[2])
        next_q[1] = q[2];             // Shift from q[2]
        next_q[0] = q[1];             // Shift from q[1]
    end

    always @(posedge clk) begin
        if (reset) begin
            q <= 5'b00001;  // synchronous reset to 1
        end else begin
            q <= next_q;
        end
    end

endmodule