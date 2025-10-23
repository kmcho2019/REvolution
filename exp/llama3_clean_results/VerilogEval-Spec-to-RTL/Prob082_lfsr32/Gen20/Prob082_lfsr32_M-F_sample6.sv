module TopModule(
    input  clk,
    input  reset,
    output reg [31:0] q
);

reg [31:0] next_q;

always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1;
    end else begin
        // Shift all bits to the right
        next_q[30:0] = q[31:1];
        // Calculate the XOR result of the taps and the LSB
        next_q[31] = q[0] ^ q[22] ^ q[1] ^ q[0];
        // Update q
        q <= next_q;
    end
end

endmodule