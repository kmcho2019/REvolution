module TopModule(
    input  clk,
    input  reset,
    output reg [31:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1;
    end else begin
        q[31] <= q[21] ^ q[1] ^ q[0]; // Correctly calculate the new MSB
        q[30:22] <= q[29:21]; // Shift bits to the right
        q[21] <= q[20] ^ q[0]; // Calculate the bit at tap position 21
        q[20:2] <= q[19:1]; // Shift bits to the right
        q[1] <= q[0]; // Shift the bit to the right
    end
end

endmodule