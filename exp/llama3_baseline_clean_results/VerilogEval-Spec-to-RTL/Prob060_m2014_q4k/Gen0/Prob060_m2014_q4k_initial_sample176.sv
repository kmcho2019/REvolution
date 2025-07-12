module TopModule (
    input clk,
    input resetn,
    input in,
    output out
);

reg [3:0] shift_reg;

always @(posedge clk) begin
    if (!resetn) begin
        // Synchronous reset, clear the shift register
        shift_reg <= 4'b0000;
    end else begin
        // Shift the bits to the left
        shift_reg <= {shift_reg[2:0], in};
    end
end

// Assign the LSB of the shift register to the output
assign out = shift_reg[0];

endmodule