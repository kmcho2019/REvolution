module Inverter (
    input  wire in,
    output wire out
);
    // Efficient combinational inversion with continuous assignment
    assign out = ~in;
endmodule

module TopModule (
    input  wire in,
    output wire out
);
    // Direct instantiation of Inverter module for clarity and minimal overhead
    Inverter u_inv (
        .in(in),
        .out(out)
    );
endmodule