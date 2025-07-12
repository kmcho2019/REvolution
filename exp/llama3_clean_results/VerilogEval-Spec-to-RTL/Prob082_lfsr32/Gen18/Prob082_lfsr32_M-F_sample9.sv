module TopModule(
    input  clk,
    input  reset,
    output reg [31:0] q
);

// Corrected tap positions considering 0-indexing
always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Reset to the specified initial value
        q <= 32'h1;
    end else begin
        // Calculate the new MSB as the XOR of the taps
        // Shift the rest of the bits to the right
        q <= {q[31] ^ q[21] ^ q[1] ^ q[0], q[31:1]};
    end
end

endmodule