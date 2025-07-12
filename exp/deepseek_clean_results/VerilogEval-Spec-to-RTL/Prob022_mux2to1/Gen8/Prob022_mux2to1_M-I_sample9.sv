module TopModule (
    input a,
    input b,
    input sel,
    output out
);
    wire sel_n;
    
    not (sel_n, sel);
    tranif1 (out, b, sel);
    tranif0 (out, a, sel_n);
endmodule