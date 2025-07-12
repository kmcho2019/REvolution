module TopModule(
    input  clk,
    input  reset,
    output reg [31:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1;
    end else begin
        q[31] <= q[30] ^ q[21] ^ q[1] ^ q[0]; // Correctly calculate the new MSB
        q[30:1] <= q[29:0]; // Shift bits to the right
        q[0] <= q[31] ^ q[30] ^ q[21] ^ q[1] ^ q[0]; // Update the LSB
    end
end

endmodule