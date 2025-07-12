// Define a parameterizable shift register module to handle n-bit data
module ShiftRegister #(
    parameter WIDTH = 8
)(
    input clk,
    input reset,
    input d,
    output logic [WIDTH-1:0] q
);

logic [WIDTH-1:0] shift_reg;

always_ff @(posedge clk) begin
    if (reset) begin
        shift_reg <= {WIDTH{1'b0}};
    end else begin
        shift_reg <= {d, shift_reg[WIDTH-1:1]};
    end
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

logic [7:0] d_shifted;

// Shift the input data to match the shift register's bit ordering
assign d_shifted = {d[0], d[1], d[2], d[3], d[4], d[5], d[6], d[7]};

ShiftRegister #(.WIDTH(8)) shift_reg(
   .clk(clk),
   .reset(reset),
   .d(d_shifted[0]),
   .q(q)
);

endmodule