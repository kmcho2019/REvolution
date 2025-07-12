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
        next_q[31:1] = q[30:0]; // Shift bits to the right
        next_q[0] = q[0]; // The LSB remains the same
        next_q[31] = q[30] ^ q[21] ^ q[1] ^ q[0]; // Correctly calculate the new MSB
        next_q[21] = q[20] ^ q[0]; // Calculate the bit at tap position 21
        next_q[1] = q[0] ^ q[0]; // The bit at position 1 is updated based on the tap
        next_q[0] = q[29] ^ q[0]; // The bit at position 0 is updated based on the tap
        q <= next_q; // Update the state of the LFSR
    end
end

endmodule