module Inverter (
    input  wire in,
    output wire out
);
    // Continuous assignment for minimal overhead inversion
    assign out = ~in;
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