module Mux2to1 (
    input  sel,
    input  in0,
    input  in1,
    output out
);
    assign out = sel ? in1 : in0;
endmodule

module TopModule (
    input  x3,
    input  x2,
    input  x1,
    output f
);
    // f = (~x3 & x2) | (x3 & x1) can be implemented as a 2:1 mux
    // controlled by x3 selecting between x2 and x1
    Mux2to1 mux_inst (
        .sel(x3),
        .in0(x2),
        .in1(x1),
        .out(f)
    );
endmodule