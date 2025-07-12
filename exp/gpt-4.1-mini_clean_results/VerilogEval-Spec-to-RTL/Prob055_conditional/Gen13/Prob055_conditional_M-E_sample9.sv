module min2(
    input  [7:0] x,
    input  [7:0] y,
    output [7:0] z
);
    assign z = (x < y) ? x : y;
endmodule

module TopModule(
    input  [7:0] a,
    input  [7:0] b,
    input  [7:0] c,
    input  [7:0] d,
    output [7:0] min
);
    wire [7:0] min_ab, min_cd;

    min2 u1 (.x(a), .y(b), .z(min_ab));
    min2 u2 (.x(c), .y(d), .z(min_cd));
    min2 u3 (.x(min_ab), .y(min_cd), .z(min));

endmodule