module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output       out
);

    wire [7:0] mux_out;
    
    // 8-bit 2-to-1 mux
    assign mux_out = sel ? b : a;
    
    // Reduction OR of all bits to match single-bit output
    assign out = |mux_out;

endmodule