module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);
    // Use a and b as mux select lines
    assign out = (a & b) ? 1'b1 :  // ab=11
                (~a & b) ? 1'b0 :  // ab=01
                (a & ~b) ? 1'b1 :  // ab=10
                c;                 // ab=00
endmodule