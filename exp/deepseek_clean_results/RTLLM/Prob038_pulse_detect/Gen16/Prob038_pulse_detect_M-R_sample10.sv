module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output data_out
);

reg [1:0] shift_reg;  // 2-bit shift register for previous states

// Output is high when we detect 010 pattern (shift_reg[1] is 1 cycle ago, shift_reg[0] is 2 cycles ago)
assign data_out = ~shift_reg[0] & shift_reg[1] & ~data_in;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        shift_reg <= 2'b00;
    end
    else begin
        shift_reg <= {shift_reg[0], data_in};  // Shift operation
    end
end

endmodule