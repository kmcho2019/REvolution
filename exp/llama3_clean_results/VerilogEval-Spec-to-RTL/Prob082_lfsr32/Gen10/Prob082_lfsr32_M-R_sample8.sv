module TopModule(
    input  clk,
    input  reset,
    output reg [31:0] q
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        q <= 32'h1;
    end else begin
        // Correctly calculate the new MSB by XORing the tapped bits (excluding the LSB) with the current LSB
        // The tap positions are at 31, 21, 1, and 0 (corrected for 0-indexed 32-bit vector)
        q <= {q[30] ^ q[20] ^ q[0] ^ q[31], q[31:1]};
    end
end

endmodule