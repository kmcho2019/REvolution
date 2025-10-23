module ring_counter(
    input clk,
    input reset,
    output reg [7:0] out
);

reg [7:0] temp_out;

// Use an 8-bit shift register to implement the ring counter
always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Load the initial state into the shift register
        out <= 8'b0000_0001;
    end else begin
        // Shift the bits one position to the right and feed the MSB back into the LSB
        temp_out = out >> 1; // Shift right by 1 bit
        temp_out[0] = out[7]; // Feed MSB back into LSB
        out <= temp_out;
    end
end

endmodule