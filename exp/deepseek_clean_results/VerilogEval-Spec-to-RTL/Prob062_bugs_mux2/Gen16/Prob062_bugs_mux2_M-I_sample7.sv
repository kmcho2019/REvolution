module TopModule (
    input        sel,
    input        en,    // New enable signal
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] out
);

    // Only drive output when enabled, else high-Z (for power reduction)
    assign out = en ? (sel ? a : b) : 8'bz;

endmodule