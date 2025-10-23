// Define a parameterizable shift register module
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
        if (reset) begin
            shift_reg <= {WIDTH{1'b0}};
        end else begin
            shift_reg <= {d[WIDTH-1], shift_reg[WIDTH-1:1]};
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

ShiftRegister #(.WIDTH(8)) shift_reg(
    .clk(clk),
    .reset(reset),
    .d(d),
    .q(q)
);

endmodule