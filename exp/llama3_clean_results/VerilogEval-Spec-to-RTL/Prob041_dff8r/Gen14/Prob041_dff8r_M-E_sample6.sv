// Define a parameterizable shift register module
module ShiftRegister #(
    parameter WIDTH = 8
)(
    input clk,
    input reset,
    input [WIDTH-1:0] d,
    output logic [WIDTH-1:0] q
);

    logic [WIDTH-1:0] q_int;
    integer i;

    always_ff @(posedge clk) begin
        if (reset) begin
            q_int <= '0;
        end else begin
            q_int <= {d[7], q_int[WIDTH-2:0]};
        end
    end

    assign q = q_int;

endmodule

// Instantiate the shift register module within the TopModule
module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output logic [7:0] q
);

ShiftRegister #(.WIDTH(8)) shift_register(
   .clk(clk),
   .reset(reset),
   .d(d),
   .q(q)
);

endmodule