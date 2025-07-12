module ring_counter(
    input clk,
    input reset,
    output reg [7:0] out
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        out <= 8'b0000_0001; // Reset to the initial state
    end else begin
        // Create a temporary variable to hold the new state
        reg [7:0] temp_out;
        // Shift the bits to the right and feed the MSB back into the LSB
        temp_out = {out[6:0], out[7]};
        out <= temp_out; // Assign the new state back to out
    end
end

endmodule