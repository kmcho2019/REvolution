module TopModule (
    input        sel,       // Selection signal
    input  [7:0] a,        // First 8-bit input
    input  [7:0] b,        // Second 8-bit input
    output [7:0] out       // 8-bit selected output
);

    // 8-bit 2-to-1 multiplexer
    // Outputs all bits of 'a' when sel=0, all bits of 'b' when sel=1
    assign out = sel ? b : a;

endmodule