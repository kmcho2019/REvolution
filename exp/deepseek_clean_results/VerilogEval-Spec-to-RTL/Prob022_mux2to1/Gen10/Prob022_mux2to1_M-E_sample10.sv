module TopModule (
    input a,
    input b,
    input sel,
    output out
);
    wire sel_n;
    
    // Generate complement of sel
    not (sel_n, sel);
    
    // Transmission gate implementation
    tranif1 (out, a, sel_n);  // Pass a when sel=0
    tranif1 (out, b, sel);    // Pass b when sel=1
endmodule