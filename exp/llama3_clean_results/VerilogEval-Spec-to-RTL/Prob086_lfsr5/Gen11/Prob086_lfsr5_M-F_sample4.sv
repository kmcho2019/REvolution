module TopModule(
    input clk,
    input reset,
    output reg [4:0] q
);

// Calculate the next state for each bit in the LFSR
always @ (posedge clk) begin
    if (reset) begin
        // Reset q to a non-zero state with the LSB set
        q <= 5'b00001; 
    end else begin
        // Update the state of the LFSR
        // The most significant bit (MSB) is the result of XORing the bits at tap positions and the LSB
        q[4] <= q[3];
        q[3] <= q[2];
        q[2] <= q[1];
        q[1] <= q[0];
        q[0] <= q[4] ^ q[2] ^ q[0];
    end
end

endmodule