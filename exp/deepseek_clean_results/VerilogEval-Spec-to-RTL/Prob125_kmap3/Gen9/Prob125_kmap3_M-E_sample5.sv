module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);
    // Use a and b as select lines for 4:1 mux
    // Data inputs determined by remaining variables
    assign out = (~a & ~b) ? 1'b0 :  // ab=00
                (~a &  b) ? (c ? 1'b0 : 1'b0) : // ab=01 (simplified from K-map)
                ( a & ~b) ? 1'b1 :  // ab=10
                1'b1;               // ab=11
endmodule