module ring_counter(
    input clk,
    input reset,
    output reg [7:0] out
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        out <= 8'b0000_0001; // Reset to initial state (LSB set to 1)
    end else begin
        // Implement cyclic shift using a more explicit and compatible method
        reg [7:0] temp;
        temp = {out[6:0], out[7]}; // Temporary variable to hold the shifted value
        out <= temp; // Assign the shifted value to the output register
    end
end

endmodule