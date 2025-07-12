// Define a shift register module to handle n-bit data
module ShiftRegister #(
    parameter WIDTH = 8
)(
    input clk,
    input reset,
    input [WIDTH-1:0] d,
    output logic [WIDTH-1:0] q
);

logic [WIDTH-1:0] shift_reg;

always_ff @(posedge clk) begin
    if (reset) shift_reg <= '0;
    else shift_reg <= {shift_reg[WIDTH-2:0], d[WIDTH-1]};
end

assign q = shift_reg;

endmodule

// Instantiate the shift register module within the TopModule
module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output logic [7:0] q
);

ShiftRegister #(.WIDTH(8)) shift_reg(
    .clk(clk),
    .reset(reset),
    .d(d),
    .q(q)
);

endmodule