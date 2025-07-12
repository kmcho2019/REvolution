module TopModule(
    input  clk,
    input  reset,
    output reg [31:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1;
    end else begin
        // Calculate the XOR of taps and LSB for the new MSB
        reg new_msb;
        new_msb = q[21] ^ q[1] ^ q[0];

        // Shift the bits to the right
        q[30:1] <= q[29:0]; // Shift all bits except the LSB to the right

        // Update the MSB with the calculated value
        q[31] <= new_msb;

        // Update bits at tap positions (excluding MSB) if necessary
        // Since our main tap for calculation is at position 21 and we've already
        // calculated the new MSB, we don't need to explicitly update q[21] here.
        // The Galois LFSR operation is correctly reflected by shifting and the new MSB calculation.
    end
end

endmodule