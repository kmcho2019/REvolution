module TopModule (
    input clk,
    input reset,
    output reg [4:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            q <= 5'b00001;
        end else begin
            // Calculate feedback bit: XOR of bits 4 and 2 XORed with LSB before shift
            // According to Galois LFSR, taps bits XORed with output bit determines next bits
            // In Galois form, the feedback is applied conditionally during the shift:
            // If LSB is 1, XOR taps into the shifted bits.
            // We'll implement accordingly:

            // Save the current LSB
            wire lsb = q[0];
            reg [4:0] next_q;

            next_q = q >> 1; // shift right

            // Apply taps XOR with lsb to bits 4 and 2
            if (lsb) begin
                next_q[4] = next_q[4] ^ 1'b1;
                next_q[2] = next_q[2] ^ 1'b1;
            end

            q <= next_q;
        end
    end

endmodule