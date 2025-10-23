module TopModule (
    input clk,
    input reset,
    output reg [4:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            q <= 5'b00001;
        end else begin
            // Calculate feedback bit (q[0])
            // taps are at bit 5 and 3 => q[4] and q[2]
            // In Galois LFSR, the bits with taps are XORed with q[0] to form their next state
            // The shift is right by 1 bit.
            // We start from MSB to LSB:
            // q[4] next = q[4] ^ q[0]
            // q[3] next = q[3]
            // q[2] next = q[2] ^ q[0]
            // q[1] next = q[1]
            // q[0] next = q[4] (the output bit shifted in)
            //
            // More simply, since it's a Galois LFSR, q shifts right by 1, but taps positions are XORed with q[0]

            wire feedback = q[0];
            q[0] <= q[1];
            q[1] <= q[2];
            q[2] <= q[3] ^ feedback;
            q[3] <= q[4];
            q[4] <= feedback ^ q[4];
        end
    end

endmodule