module right_shifter (
    input wire clk,
    input wire d,
    output wire [7:0] q
);

// Internal register
reg [7:0] shift_reg = 8'b0;

// Continuous assignment for output
assign q = shift_reg;

// Shift operation on clock edge
always @(posedge clk) begin
    shift_reg <= {d, shift_reg[7:1]};
end

endmodule