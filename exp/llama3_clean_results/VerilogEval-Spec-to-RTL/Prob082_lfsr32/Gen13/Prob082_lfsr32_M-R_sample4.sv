module TopModule(
    input  clk,
    input  reset,
    output reg [31:0] q
);

// Combinational logic to calculate the new MSB
wire new_msb = q[0] ^ q[1] ^ q[21] ^ q[31];

always @(posedge clk or posedge reset) begin
    if (reset) begin
        q <= 32'h1; // Reset to 1
    end else begin
        // Shift the register to the right, preserving bits without taps
        // and updating bits with taps according to the Galois LFSR behavior
        q[31:1] <= q[30:0]; // Shift bits without considering taps
        q[0] <= new_msb; // Update the LSB with the new MSB value
    end
end

endmodule