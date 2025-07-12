module TopModule(
    input  clk,
    input  reset,
    output reg [31:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1;
    end else begin
        // Apply taps first
        q[31] = q[31] ^ q[0]; // Tap at MSB (position 32 in problem description, but actually 31)
        q[22] = q[22] ^ q[0]; // Apply tap at 22
        q[2] = q[2] ^ q[0]; // Apply tap at 2
        q[1] = q[1] ^ q[0]; // Apply tap at 1
        // Shift all bits to the right
        q <= {q[30:0], 1'b0}; // Shift and set the LSB to 0
    end
end

endmodule