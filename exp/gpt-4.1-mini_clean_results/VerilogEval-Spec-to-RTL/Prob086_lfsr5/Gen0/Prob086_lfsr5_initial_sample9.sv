module TopModule (
    input clk,
    input reset,
    output reg [4:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 5'b00001; // Initialize to 1 on reset
    end else begin
        // Galois LFSR with taps at bit positions 5 and 3:
        // taps on q[4] and q[2], XOR with q[0] feedback bit
        // Shift right by one, but tap positions XOR with q[0]
        // q[0] <= q[1]
        // q[1] <= q[2]
        // q[2] <= q[3] ^ q[0]
        // q[3] <= q[4]
        // q[4] <= q[0]

        // Calculate feedback bit
        wire feedback = q[0];

        // Calculate next bits
        q[0] <= q[1];
        q[1] <= q[2];
        q[2] <= q[3] ^ feedback;
        q[3] <= q[4];
        q[4] <= feedback;
    end
end

endmodule