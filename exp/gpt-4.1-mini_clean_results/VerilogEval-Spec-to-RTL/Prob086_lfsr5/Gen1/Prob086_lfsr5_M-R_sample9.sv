module TopModule (
    input clk,
    input reset,
    output reg [4:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            q <= 5'b00001;
        end else begin
            // Store feedback bit (LSB of current q)
            reg feedback;
            feedback = q[0];

            // Update LFSR bits based on Galois LFSR with taps at bit 5 (q[4]) and bit 3 (q[2])
            q <= {
                q[4] ^ feedback, // bit 5 tap XOR feedback
                q[4],            // bit 4 shifts from bit 5
                q[3] ^ feedback, // bit 3 tap XOR feedback
                q[2],            // bit 2 shifts from bit 3
                q[1]             // bit 1 shifts from bit 2
            };
        end
    end

endmodule