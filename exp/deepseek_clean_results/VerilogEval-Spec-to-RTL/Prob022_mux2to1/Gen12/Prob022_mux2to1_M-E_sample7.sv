module TopModule (
    input wire a,
    input wire b,
    input wire sel,
    output wire out
);
    wire mux_out;
    
    // Transmission gate implementation
    tranif0 tg_a(mux_out, a, sel);  // Pass a when sel=0
    tranif1 tg_b(mux_out, b, sel);  // Pass b when sel=1
    
    // Output buffer for drive strength
    buf b1(out, mux_out);
endmodule