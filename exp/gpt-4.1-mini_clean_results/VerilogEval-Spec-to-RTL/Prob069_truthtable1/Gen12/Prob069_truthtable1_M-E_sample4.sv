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
    wire not_x3;
    wire and_term;
    wire or_term;

    // not_x3 = ~x3
    NOT1 not_gate(.a(x3), .y(not_x3));
    // and_term = ~x3 & x2
    AND2 and_gate(.a(not_x3), .b(x2), .y(and_term));
    // or_term = x3 | x2
    OR2 or_gate(.a(x3), .b(x2), .y(or_term));
    // f = mux between and_term (d0) and or_term (d1) by x1
    MUX2to1 mux(.sel(x1), .d0(and_term), .d1(or_term), .y(f));
endmodule