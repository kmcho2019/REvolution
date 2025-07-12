module right_shifter (
    input wire clk,
    input wire d,
    output wire [7:0] q
);

reg [7:0] shift_reg = 8'b0;

// Shift operation: right shift and insert new bit at MSB
wire [7:0] next_shift = {d, shift_reg[7:1]};

// Update register on clock edge
always @(posedge clk) begin
    shift_reg <= next_shift;
end

// Continuous output assignment
assign q = shift_reg;

endmodule