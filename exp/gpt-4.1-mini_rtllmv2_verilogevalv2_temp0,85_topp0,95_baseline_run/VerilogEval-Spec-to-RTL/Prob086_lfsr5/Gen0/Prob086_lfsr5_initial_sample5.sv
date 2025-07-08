module TopModule(
    input clk,
    input reset,
    output reg [4:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            q <= 5'b00001;
        end else begin
            // Galois LFSR with taps at bit 5 and 3 (q[4] and q[2])
            // feedback bit = q[0]
            // tapped bits XOR with feedback
            q[0] <= q[1];
            q[1] <= q[2];
            q[2] <= q[3] ^ q[0];
            q[3] <= q[4];
            q[4] <= q[0] ^ q[4];
        end
    end

endmodule