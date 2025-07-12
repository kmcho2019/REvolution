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
    // Intermediate minimum wires using min2 modules for modular clarity
    wire [7:0] min_ab;
    wire [7:0] min_cd;

    // Instantiate min2 modules for first stage of balanced tree
    min2 u_min2_ab (.x(a), .y(b), .z(min_ab));
    min2 u_min2_cd (.x(c), .y(d), .z(min_cd));

    // Final minimum computed combinationally with continuous assignment (no always block)
    assign min = (min_ab < min_cd) ? min_ab : min_cd;

endmodule