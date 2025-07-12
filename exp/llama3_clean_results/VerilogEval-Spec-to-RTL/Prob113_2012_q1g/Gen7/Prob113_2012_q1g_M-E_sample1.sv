module TopModule(
    input  [3:0] x,
    output       f
);

    wire f_00, f_01, f_11, f_10;

    // Implement each section of the Karnaugh map separately
    section_00 section_00_inst(
        .x0(x[0]),
        .x1(x[1]),
        .f(f_00)
    );

    section_01 section_01_inst(
        .x0(x[0]),
        .x1(x[1]),
        .f(f_01)
    );

    section_11 section_11_inst(
        .x0(x[0]),
        .x1(x[1]),
        .f(f_11)
    );

    section_10 section_10_inst(
        .x0(x[0]),
        .x1(x[1]),
        .f(f_10)
    );

    // Combine the outputs from each section
    assign f = (~x[2] & ~x[3] & f_00) |
               (~x[2] & x[3] & f_01) |
               (x[2] & x[3] & f_11) |
               (x[2] & ~x[3] & f_10);

endmodule

// Module for section x[2]x[3] = 00
module section_00(
    input  x0,
    input  x1,
    output f
);

    assign f = (~x0 & ~x1) | (x0 & ~x1);

endmodule

// Module for section x[2]x[3] = 01
module section_01(
    input  x0,
    input  x1,
    output f
);

    assign f = 1'b0;

endmodule

// Module for section x[2]x[3] = 11
module section_11(
    input  x0,
    input  x1,
    output f
);

    assign f = (~x0 & ~x1) | (~x0 & x1) | (x0 & x1);

endmodule

// Module for section x[2]x[3] = 10
module section_10(
    input  x0,
    input  x1,
    output f
);

    assign f = (~x0 & ~x1) | (~x0 & x1) | (x0 & ~x1);

endmodule