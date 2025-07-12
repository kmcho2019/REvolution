module TopModule(
    input  clk,
    input  reset,
    output reg [31:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1;
    end else begin
        reg [31:0] next_q;
        // Shift all bits to the right
        next_q[31:1] = q[30:0];
        // Calculate the XOR result of the taps and the LSB
        next_q[0] = q[31] ^ q[21] ^ q[1] ^ q[0];
        // Update the bits at tap positions
        next_q[22] = q[21] ^ next_q[0];
        next_q[2] = q[1] ^ next_q[0];
        next_q[1] = q[0] ^ next_q[0];
        q <= next_q;
    end
end

endmodule