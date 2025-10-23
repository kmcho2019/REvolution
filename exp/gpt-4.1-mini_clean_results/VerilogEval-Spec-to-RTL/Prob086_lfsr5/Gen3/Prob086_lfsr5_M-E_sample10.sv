module TopModule (
    input       clk,
    input       reset,
    output reg [4:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            q <= 5'b00001;
        end else begin
            // feedback = XOR of q[0] (LSB) with q[2] and q[4] taps
            wire feedback = q[0] ^ q[2] ^ q[4];

            // Shift right by 1 bit, updating tapped positions with feedback
            q <= {feedback, q[4:1]};
        end
    end

endmodule