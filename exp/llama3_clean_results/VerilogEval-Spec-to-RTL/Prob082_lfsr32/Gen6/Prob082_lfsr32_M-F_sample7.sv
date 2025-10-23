module TopModule(
    input  clk,
    input  reset,
    output reg [31:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1;
    end else begin
        // Calculate the new MSB based on the taps and the current LSB
        // Note: The calculation here directly influences the MSB, considering the standard Galois LFSR operation
        q[31] <= q[0] ^ q[21] ^ q[1] ^ q[0];
        // Shift the rest of the bits to the right
        for (int i = 30; i >= 0; i--) begin
            q[i] <= q[i+1];
        end
    end
end

endmodule