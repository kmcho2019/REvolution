module TopModule (
    input  clk,
    input  resetn,
    input  in,
    output out
);

reg [3:0] shift_reg;

always @(posedge clk) begin
    if (!resetn) begin
        shift_reg <= 4'b0000; // Reset shift register to zero on reset
    end else begin
        shift_reg <= {shift_reg[2:0], in}; // Shift in new data
    end
end

assign out = shift_reg[3]; // Output the most significant bit of the shift register

endmodule