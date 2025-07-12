module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] out
);

    assign out = sel ? b : a;  // Select full 8-bit vector from either a or b

endmodule