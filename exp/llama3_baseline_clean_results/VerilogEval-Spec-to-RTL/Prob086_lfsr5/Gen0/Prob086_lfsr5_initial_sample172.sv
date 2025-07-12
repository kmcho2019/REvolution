module TopModule (
    input clk,
    input reset,
    output reg [4:0] q
);

always @(posedge clk) begin
    if (reset) begin
        // Reset the LFSR output to 1
        q <= 1;
    end else begin
        // XOR the LSB output with the tapped positions (5 and 3) to produce the next MSB
        q[4] <= q[0] ^ q[2];
        // Shift right the rest of the bits
        q[3:1] <= q[2:0];
    end
end

endmodule