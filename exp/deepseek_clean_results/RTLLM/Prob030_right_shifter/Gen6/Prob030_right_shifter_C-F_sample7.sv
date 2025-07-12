module right_shifter (
    input clk,
    input d,
    output [7:0] q
);

reg [7:0] shift_reg;
wire [7:0] next_val;

// Clear combinational shift operation
assign next_val = {d, shift_reg[7:1]};

// Synchronous register update
always @(posedge clk) begin
    shift_reg <= next_val;
end

// Output assignment
assign q = shift_reg;

// Initialization through power-on reset
initial begin
    shift_reg = 8'b0;
end

endmodule