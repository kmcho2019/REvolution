module TopModule(
    input clk,
    input resetn,
    input in,
    output out
);

reg [3:0] shift_reg;

always @(posedge clk) begin
    if (~resetn) begin
        // Synchronous reset: set all bits to 0 when resetn is low
        shift_reg <= 4'b0000;
    end else begin
        // Shift the input into the shift register on each clock cycle
        shift_reg <= {shift_reg[2:0], in};
    end
end

// Output the MSB of the shift register
assign out = shift_reg[3];

endmodule