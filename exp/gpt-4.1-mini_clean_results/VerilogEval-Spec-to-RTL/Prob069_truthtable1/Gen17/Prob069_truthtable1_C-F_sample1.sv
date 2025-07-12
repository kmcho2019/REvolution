module AND2 (
    input  wire a,
    input  wire b,
    output wire y
);
    assign y = a & b;
endmodule

module OR2 (
    input  wire a,
    input  wire b,
    output wire y
);
    assign y = a | b;
endmodule

// 2:1 MUX implemented structurally using AND2 and OR2,
// with inversion done by continuous assignment to reduce gate count
module MUX2to1 (
    input  wire sel,
    input  wire d0,
    input  wire d1,
    output wire y
);
    wire nsel;
    wire s0, s1;

    assign nsel = ~sel;

    AND2 and0 (.a(d0),  .b(nsel), .y(s0));
    AND2 and1 (.a(d1),  .b(sel),  .y(s1));
    OR2  or0  (.a(s0),  .b(s1),  .y(y));
endmodule

module TopModule (
    input  wire x3,
    input  wire x2,
    input  wire x1,
    output wire f
);
    // f = mux controlled by x3: if x3=0 -> x2 else x1
    MUX2to1 mux_inst (
        .sel(x3),
        .d0(x2),
        .d1(x1),
        .y(f)
    );
endmodule