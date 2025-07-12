module right_shifter (
    input wire clk,
    input wire d,
    output wire [7:0] q
);

reg [7:0] shift_reg = 8'b0;  // Initialize to 0

// Combinational shift operation
wire [7:0] next_shift = {d, shift_reg[7:1]};

// Sequential update
always @(posedge clk) begin
    shift_reg <= next_shift;
end

assign q = shift_reg;

endmodule