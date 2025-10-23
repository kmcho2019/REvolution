module NandGate (
    input  wire x,
    input  wire y,
    output wire z
);
    assign z = ~(x & y);
endmodule

module AndViaNand (
    input  wire a,
    input  wire b,
    output wire y
);
    wire nand_out;

    NandGate nand1 (
        .x(a),
        .y(b),
        .z(nand_out)
    );

    NandGate nand2 (
        .x(nand_out),
        .y(nand_out),
        .z(y)
    );
endmodule

module TopModule (
    input  wire a,
    input  wire b,
    output wire q
);
    AndViaNand and_instance (
        .a(a),
        .b(b),
        .y(q)
    );
endmodule