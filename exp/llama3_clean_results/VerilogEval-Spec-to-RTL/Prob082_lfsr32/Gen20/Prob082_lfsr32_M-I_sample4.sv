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
        next_q[31:1] = q[30:0];
        // Calculate the new LSB
        next_q[0] = q[31] ^ q[21] ^ q[1] ^ q[0];
        // Update the bits at tap positions
        q[31] <= next_q[0];
        q[30:22] <= q[29:21];
        q[21] <= next_q[0] ^ q[21];
        q[20:2] <= q[19:1];
        q[1] <= next_q[0] ^ q[1];
        q[0] <= next_q[0];
    end
end

endmodule