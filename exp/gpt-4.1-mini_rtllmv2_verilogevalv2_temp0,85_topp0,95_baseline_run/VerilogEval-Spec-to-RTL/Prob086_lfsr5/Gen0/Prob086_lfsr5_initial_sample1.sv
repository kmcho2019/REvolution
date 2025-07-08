module TopModule (
    input clk,
    input reset,
    output reg [4:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            q <= 5'b00001;
        end else begin
            // taps at bit 5 and 3 -> zero-based bits 4 and 2
            // XOR tap bits with LSB before shifting right
            // Save LSB before shifting
            wire feedback = q[0];
            q <= { (q[4] ^ feedback), q[4:3], (q[2] ^ feedback), q[2:1] };
            // Correctly assign bits:
            // q[4] <= q[4] ^ feedback
            // q[3] <= q[4]
            // q[2] <= q[2] ^ feedback
            // q[1] <= q[2]
            // q[0] <= q[1]
            // Let's write explicitly to avoid confusion:

            // Using a temporary register for clarity
        end
    end

    // Because we cannot declare wire inside always block, we need to use a different approach:
    always @(posedge clk) begin
        if (reset) begin
            q <= 5'b00001;
        end else begin
            wire feedback = q[0];
            reg [4:0] next_q;
            next_q[4] = q[4] ^ feedback;
            next_q[3] = q[4];
            next_q[2] = q[2] ^ feedback;
            next_q[1] = q[2];
            next_q[0] = q[1];
            q <= next_q;
        end
    end

endmodule