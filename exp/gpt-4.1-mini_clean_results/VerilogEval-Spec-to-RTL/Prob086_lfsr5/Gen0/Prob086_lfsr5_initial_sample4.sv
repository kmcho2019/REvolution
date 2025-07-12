module TopModule(
    input clk,
    input reset,
    output reg [4:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 5'b00001;
    end else begin
        // Galois LFSR step with taps at bit 5 (q[4]) and bit 3 (q[2])
        // feedback bit is q[0]
        // Each bit shifts right, but tapped bits get XORed with q[0]
        q[0] <= q[1];
        q[1] <= q[2];
        q[2] <= q[3] ^ q[0]; // tap at bit 3 (q[2])
        q[3] <= q[4];
        q[4] <= q[0];        // tap at bit 5 (q[4])
    end
end

endmodule