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
        next_q = {q[30:0], q[31]}; // Shift all bits to the right
        // Apply taps sequentially
        next_q[31] = q[31] ^ q[0]; // Tap at MSB (position 32 in problem description, but actually 31)
        next_q[22] = next_q[22] ^ q[0]; // Apply tap at 22
        next_q[2] = next_q[2] ^ q[0]; // Apply tap at 2
        next_q[1] = next_q[1] ^ q[0]; // Apply tap at 1
        q <= next_q;
    end
end

endmodule