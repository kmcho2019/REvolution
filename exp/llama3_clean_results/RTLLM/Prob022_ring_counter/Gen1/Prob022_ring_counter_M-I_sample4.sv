module ring_counter(
    input clk,
    input reset,
    output reg [7:0] out
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        out <= 8'b0000_0001; // Initialize to starting state when reset is high
    end else begin
        // Perform a cyclic shift by moving the MSB to the LSB position
        out <= {out[6:0], out[7]};
        // Alternatively, the above line could be implemented using a temporary variable for clarity:
        // reg [7:0] next_out;
        // next_out = {out[6:0], out[7]};
        // out <= next_out;
    end
end

endmodule