module TopModule (
    input        clk,
    input        reset,
    output reg [4:0] q
);

    // Galois LFSR taps at bits 5 and 3 correspond to q[4] and q[2]
    wire feedback;
    assign feedback = q[0];  // The bit shifted out (LSB)

    always @(posedge clk) begin
        if (reset) begin
            q <= 5'b00001;  // synchronous active-high reset to 1
        end else begin
            // Update each bit according to Galois LFSR rules:
            // tapped bits xor with feedback bit
            // others just shift from the next higher bit
            q[0] <= q[1];
            q[1] <= q[2];
            q[2] <= q[3] ^ feedback;  // tap at bit 3 (q[2])
            q[3] <= q[4];
            q[4] <= q[4] ^ feedback;  // tap at bit 5 (q[4])
        end
    end

endmodule