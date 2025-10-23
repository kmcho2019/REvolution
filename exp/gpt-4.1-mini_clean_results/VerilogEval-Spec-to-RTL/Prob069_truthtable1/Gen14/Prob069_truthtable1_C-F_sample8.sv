module AND2 (
    input a,
    input b,
    output y
);
    assign y = a & b;
endmodule

module OR2 (
    input a,
    input b,
    output y
);
    assign y = a | b;
endmodule

module NOT1 (
    input a,
    output y
);
    assign y = ~a;
endmodule

// 2:1 MUX implemented structurally using gates
module MUX2to1 (
    input  sel,
    input  d0,
    input  d1,
    output y
);
    wire nsel, s0, s1;

    NOT1 not_sel(.a(sel), .y(nsel));
    AND2 and0(.a(d0), .b(nsel), .y(s0));
    AND2 and1(.a(d1), .b(sel), .y(s1));
    OR2  or0 (.a(s0), .b(s1), .y(y));
endmodule

module TopModule (
    input  x3,
    input  x2,
    input  x1,
    output f
);
    // f = mux controlled by x3: if x3=0 -> x2 else x1
    MUX2to1 mux_inst (
        .sel(x3),
        .d0(x2),
        .d1(x1),
        .y(f)
    );
endmodule