module BitwiseOR3 (
    input [2:0] a,
    input [2:0] b,
    output [2:0] out
);
    // Parallel OR gates for bitwise operation
    or or0(out[0], a[0], b[0]);
    or or1(out[1], a[1], b[1]);
    or or2(out[2], a[2], b[2]);
endmodule

module LogicalOR3 (
    input [2:0] a,
    input [2:0] b,
    output out
);
    // Reduction OR tree
    wire intermediate_or;
    or or0(intermediate_or, a[0], b[0]);
    or or1(intermediate_or, intermediate_or, a[1], b[1]);
    or or2(out, intermediate_or, a[2], b[2]);
endmodule

module Inverter6 (
    input [2:0] a,
    input [2:0] b,
    output [5:0] out
);
    // Parallel inverters with concatenated outputs
    not inv0(out[0], a[0]);
    not inv1(out[1], a[1]);
    not inv2(out[2], a[2]);
    not inv3(out[3], b[0]);
    not inv4(out[4], b[1]);
    not inv5(out[5], b[2]);
endmodule

module TopModule (
    input [2:0] a,
    input [2:0] b,
    output [2:0] out_or_bitwise,
    output out_or_logical,
    output [5:0] out_not
);
    // Instantiate specialized processing units
    BitwiseOR3 bitwise_or_unit (
        .a(a),
        .b(b),
        .out(out_or_bitwise)
    );
    
    LogicalOR3 logical_or_unit (
        .a(a),
        .b(b),
        .out(out_or_logical)
    );
    
    Inverter6 not_unit (
        .a(a),
        .b(b),
        .out(out_not)
    );
endmodule