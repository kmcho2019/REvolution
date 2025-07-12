module TopModule(
    input clk,
    input reset,
    output reg [4:0] q
);

always @(posedge clk) begin
    if (reset)
        q <= 5'b00001;
    else begin
        // Apply Galois LFSR with taps at bit 5 (q[4]) and bit 3 (q[2])
        // feedback bit is q[0]
        // new bits:
        // q[4] <= q[0] ^ q[4]
        // q[3] <= q[4]
        // q[2] <= q[0] ^ q[2]
        // q[1] <= q[3]
        // q[0] <= q[1]
        q <= {q[0] ^ q[4], q[4], q[0] ^ q[2], q[3], q[1]};
    end
end

endmodule