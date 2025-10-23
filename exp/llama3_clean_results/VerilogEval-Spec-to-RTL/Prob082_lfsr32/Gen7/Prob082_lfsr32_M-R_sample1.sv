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
        q <= next_q;
    end
end

always @(*) begin
    // Calculate the feedback term (XOR of the taps excluding the LSB)
    reg fb;
    assign fb = q[31] ^ q[21] ^ q[1];
    
    // Shift the current state to the right and update the MSB with the feedback term
    next_q[31] = fb;
    for (int i = 30; i >= 0; i--) begin
        next_q[i] = q[i+1];
    end
    next_q[0] = 1'b0; // Ensuring the LSB is correctly set after shifting
end

endmodule