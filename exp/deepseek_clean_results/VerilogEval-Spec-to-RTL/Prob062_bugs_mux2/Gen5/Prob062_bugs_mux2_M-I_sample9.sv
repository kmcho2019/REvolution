module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] out
);

    // Select between full 8-bit inputs a and b based on sel
    assign out = sel ? b : a;

endmodule