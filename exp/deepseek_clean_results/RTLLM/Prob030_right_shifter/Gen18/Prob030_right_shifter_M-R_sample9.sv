module right_shifter (
    input wire clk,
    input wire d,
    output wire [7:0] q
);

reg [7:0] shift_reg = 8'b0;

// Combinational shift operation
assign q = shift_reg;

// Sequential update using continuous assignment
always @(posedge clk) begin
    shift_reg <= {d, shift_reg[7:1]};
end

endmodule