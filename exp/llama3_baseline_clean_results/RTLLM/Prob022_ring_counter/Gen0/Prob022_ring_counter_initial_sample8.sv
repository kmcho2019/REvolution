module ring_counter(
    input clk,
    input reset,
    output reg [7:0] out
);

always @ (posedge clk or posedge reset) begin
    if (reset) begin
        out <= 8'b0000_0001; // Reset the counter to its initial state
    end else begin
        if (out == 8'b1000_0000) begin
            out <= 8'b0000_0001; // Wrap around to the LSB after MSB
        end else begin
            // Shift the '1' to the next bit position
            out <= {out[6:0], out[7]}; 
        end
    end
end

endmodule