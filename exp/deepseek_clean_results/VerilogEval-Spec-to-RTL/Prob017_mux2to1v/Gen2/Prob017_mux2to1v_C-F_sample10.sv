module TopModule (
    input  [99:0] a,    // 100-bit input A
    input  [99:0] b,    // 100-bit input B
    input         sel,  // Selection signal (0: select A, 1: select B)
    output [99:0] out   // 100-bit output
);

    // 100-bit 2:1 multiplexer
    assign out = sel ? b : a;

endmodule