module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] out
);

    // Select entire 8-bit vector a or b based on sel
    assign out = sel ? b : a;

endmodule