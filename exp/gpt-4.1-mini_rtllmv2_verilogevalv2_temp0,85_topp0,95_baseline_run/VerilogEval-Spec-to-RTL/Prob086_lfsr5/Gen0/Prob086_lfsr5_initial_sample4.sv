module TopModule (
    input clk,
    input reset,
    output reg [4:0] q
);

    // On reset, set q to 1
    // On each clock, perform the Galois LFSR shift with taps at bits 5 and 3 (index 4 and 2)
    always @(posedge clk) begin
        if (reset) begin
            q <= 5'b00001;
        end else begin
            // Save current LSB as feedback bit
            wire feedback = q[0];

            // Next state logic for each bit:
            // q[4]: XOR with feedback (tap at bit 5)
            // q[3]: no tap, shift from q[4]
            // q[2]: XOR with feedback (tap at bit 3)
            // q[1]: no tap, shift from q[2]
            // q[0]: shift from q[1]

            q[4] <= q[4] ^ feedback;
            q[3] <= q[4];
            q[2] <= q[2] ^ feedback;
            q[1] <= q[2];
            q[0] <= q[1];
        end
    end

endmodule