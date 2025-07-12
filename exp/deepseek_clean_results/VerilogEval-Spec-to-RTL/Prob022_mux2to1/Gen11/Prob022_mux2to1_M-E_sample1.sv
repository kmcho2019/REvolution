module TopModule (
    input a,
    input b,
    input sel,
    output out
);
    wire sel_n;
    wire out_a, out_b;
    
    // Generate complementary select signal
    assign sel_n = ~sel;
    
    // Transmission gate implementation
    tranif1 tg_a(out_a, a, sel_n);  // Pass a when sel=0
    tranif0 tg_b(out_b, b, sel);    // Pass b when sel=1
    
    // Combine the outputs (wired OR)
    assign out = out_a | out_b;
endmodule