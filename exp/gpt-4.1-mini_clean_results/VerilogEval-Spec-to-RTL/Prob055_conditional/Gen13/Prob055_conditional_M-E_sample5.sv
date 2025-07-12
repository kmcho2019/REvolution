module min2(
    input  [7:0] x,
    input  [7:0] y,
    output [7:0] min_out
);
    assign min_out = (x < y) ? x : y;
endmodule

module TopModule(
    input  [7:0] a,
    input  [7:0] b,
    input  [7:0] c,
    input  [7:0] d,
    output [7:0] min
);
    wire [7:0] min_ab, min_cd;

    // Compute min of a and b
    min2 u_min2_ab(.x(a), .y(b), .min_out(min_ab));
    // Compute min of c and d
    min2 u_min2_cd(.x(c), .y(d), .min_out(min_cd));
    // Compute min of min_ab and min_cd
    min2 u_min2_final(.x(min_ab), .y(min_cd), .min_out(min));
endmodule