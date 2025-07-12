module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

reg [7:0] q_reg;

// Use a single always block for clocked behavior
always @(negedge clk) begin
    if (reset) begin
        // Reset the register to 0x34 (52 in decimal) on reset
        q_reg <= 8'd52;
    end else begin
        // On the negative edge of the clock, assign the input to the register
        q_reg <= d;
    end
end

// Assign the internal register to the output
assign q = q_reg;

endmodule