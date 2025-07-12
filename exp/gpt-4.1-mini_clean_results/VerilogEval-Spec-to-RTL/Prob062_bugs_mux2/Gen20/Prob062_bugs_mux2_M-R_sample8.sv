module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] out
);

    // 8-bit 2-to-1 mux using bitwise operations and continuous assignment
    assign out = (~{8{sel}} & a) | ({8{sel}} & b);

endmodule