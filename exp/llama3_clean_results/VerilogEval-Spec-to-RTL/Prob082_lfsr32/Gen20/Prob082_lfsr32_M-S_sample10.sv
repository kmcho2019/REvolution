module TopModule(
    input  clk,
    input  reset,
    output reg [31:0] q
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        q <= 32'h1;
    end else begin
        reg [31:0] new_q;
        new_q = q >> 1; // Shift all bits to the right
        
        // Update tapped positions based on XOR with the current LSB
        new_q[31] = q[0]; // Directly use the current LSB as the new MSB
        new_q[21] = new_q[21] ^ q[0]; // Update tap at position 22 (0-indexed as 21)
        new_q[1] = new_q[1] ^ q[0]; // Update tap at position 2
        new_q[0] = q[31] ^ q[21] ^ q[1] ^ q[0]; // The new LSB is the XOR of the taps
        
        q <= new_q;
    end
end

endmodule