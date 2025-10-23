module ring_counter(
    input clk,
    input reset,
    output [7:0] out
);

reg [7:0] out_reg;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Initialize the counter to its starting state
        out_reg <= 8'b0000_0001;
    end else begin
        // Shift the 1 bit to the next position, wrapping around to the LSB
        out_reg <= {out_reg[6:0], out_reg[7]};
    end
end

// Continuous assignment to output
assign out = out_reg;

endmodule