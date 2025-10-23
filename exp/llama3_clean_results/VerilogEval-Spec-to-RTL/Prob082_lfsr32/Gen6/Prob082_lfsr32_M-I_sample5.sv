module TopModule(
    input  clk,
    input  reset,
    output reg [31:0] q
);

reg [31:0] next_q;

always @(*) begin
    next_q[31] = q[0]; // Most significant bit is the new least significant bit
    for (int i = 30; i >= 0; i--) begin
        next_q[i] = q[i + 1]; // Shift the rest of the bits
    end
    next_q[0] = q[31] ^ q[21] ^ q[1] ^ q[0]; // Calculate the new least significant bit
end

always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1; // Reset the LFSR to 1
    end else begin
        q <= next_q; // Update the LFSR state
    end
end

endmodule