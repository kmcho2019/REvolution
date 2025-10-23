module right_shifter (
    input wire clk,
    input wire d,
    output wire [7:0] q
);

// Internal register
reg [7:0] shift_reg = 8'b0;

// Continuous assignment for output
assign q = shift_reg;

// Shift logic using concatenation
wire [7:0] next_shift = {d, shift_reg[7:1]};

// Register update on clock edge
always @(posedge clk) begin
    shift_reg <= next_shift;
end

endmodule