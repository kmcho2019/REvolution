module right_shifter (
    input clk,
    input d,
    output [7:0] q
);

reg [7:0] shift_reg = 8'b0;

always @(posedge clk) begin
    // Combined right shift and MSB insertion
    shift_reg <= {d, shift_reg[7:1]};
end

assign q = shift_reg;

endmodule