module Inverter (
    input  wire in,
    output reg  out
);
    // Procedural combinational inversion to allow easy future logic changes
    always @(*) begin
        out = ~in;
    end
endmodule

module TopModule (
    input  wire in,
    output wire out
);
    Inverter u_inv (
        .in(in),
        .out(out)
    );
endmodule