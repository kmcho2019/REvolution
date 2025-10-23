module TopModule(
    input clk,
    input resetn,
    input in,
    output out
);

reg [3:0] shift_reg; // 4-bit shift register

always @(posedge clk) begin
    if (~resetn) begin
        // Synchronous active-low reset
        shift_reg <= 4'b0000;
    end else begin
        // Shift the register on the positive edge of the clock
        shift_reg <= {shift_reg[2:0], in};
    end
end

assign out = shift_reg[3]; // Output is the MSB of the shift register

endmodule