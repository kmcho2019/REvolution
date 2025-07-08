module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    // Tap positions (1-based): 32, 22, 2, 1
    // Zero-based indices: 31, 21, 1, 0

    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            wire feedback = q[0];
            // Shift right by 1
            // For tapped bits, XOR with feedback
            // Build next state bit by bit
            // new_q[31] = q[30] ^ feedback (if tapped at 32)
            // new_q[21] = q[20] ^ feedback (tapped at 22)
            // new_q[1]  = q[0]  ^ feedback (tapped at 2)
            // new_q[0]  = feedback (LSB after shift is just feedback)
            // other bits shift down by 1 without change

            // We'll construct the next q
            reg [31:0] next_q;
            integer i;

            next_q[0] = feedback;

            for (i = 1; i < 32; i = i + 1) begin
                // Check if current bit i is tapped
                if (i == 31 || i == 21 || i == 1) begin
                    next_q[i] = q[i-1] ^ feedback;
                end else begin
                    next_q[i] = q[i-1];
                end
            end

            q <= next_q;
        end
    end

endmodule