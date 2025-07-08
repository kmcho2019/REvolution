module TopModule(
    input clk,
    input reset,
    output reg [4:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            q <= 5'b00001;
        end else begin
            // Calculate feedback bit as XOR of q[0], q[4], and q[2]
            // According to Galois LFSR, only tapped bits XOR with LSB
            // The feedback bit is q[0] xor q[4] xor q[2].
            // The shift is to the right, MSB gets the feedback bit
            // Bits without taps shift right normally.
            // Implementation: 
            // new MSB = q[0] ^ q[4] ^ q[2]
            // q[4] = new MSB
            // q[3] = q[4]
            // q[2] = q[3]
            // q[1] = q[2]
            // q[0] = q[1]

            wire feedback = q[0] ^ q[4] ^ q[2];
            q <= {feedback, q[4:1]};
        end
    end

endmodule