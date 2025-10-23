module TopModule (
    input        sel,
    input        en,    // Added enable signal
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] out
);

    assign out = en ? (sel ? a : b) : 8'b0;

endmodule