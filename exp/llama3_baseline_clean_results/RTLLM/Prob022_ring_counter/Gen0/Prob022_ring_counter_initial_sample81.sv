module ring_counter(
    input clk,
    input reset,
    output reg [7:0] out
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            out <= 8'b0000_0001; // Initialize to starting state with LSB set to 1
        end else begin
            // Shift the output to the right and wrap around to the MSB if necessary
            out <= {out[6:0], out[7]}; // Rotate the bits
        end
    end

endmodule