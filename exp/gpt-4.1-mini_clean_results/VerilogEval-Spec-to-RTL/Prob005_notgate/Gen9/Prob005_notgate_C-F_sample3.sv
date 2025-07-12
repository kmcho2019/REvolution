module Inverter (
    input  wire in,
    output wire out
);
    // Simple continuous assignment to minimize power and area
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