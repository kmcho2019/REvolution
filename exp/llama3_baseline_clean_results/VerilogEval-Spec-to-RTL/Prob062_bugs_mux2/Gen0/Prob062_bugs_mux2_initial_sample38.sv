module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] out  // Changed output to 8 bits wide
);

    assign out = (~sel & a) | (sel & b);  // This works due to bitwise operations in Verilog

endmodule