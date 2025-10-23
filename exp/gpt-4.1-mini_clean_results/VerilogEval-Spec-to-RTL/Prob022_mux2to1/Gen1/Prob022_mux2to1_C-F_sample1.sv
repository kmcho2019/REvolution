module TopModule (
    input  wire a,    // Input bit a
    input  wire b,    // Input bit b
    input  wire sel,  // Select signal
    output wire out   // Output bit
);

// 2-to-1 mux: out = a when sel=0, out = b when sel=1
assign out = sel ? b : a;

endmodule