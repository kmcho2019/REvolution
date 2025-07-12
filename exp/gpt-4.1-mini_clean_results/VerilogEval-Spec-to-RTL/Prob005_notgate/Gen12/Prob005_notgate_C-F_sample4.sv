module Inverter (
    input  wire in,
    output wire out
);
    // Pure continuous assignment for minimal power, area, and delay
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