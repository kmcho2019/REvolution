module TopModule(
    input a,
    input b,
    input c,
    input d,  // Unused
    output out
);
    // Implement as 4:1 mux with a,b as select lines
    assign out = (a & b) ? 1'b1 :  // 11 case
                 (a & ~b) ? 1'b1 : // 10 case
                 (~a & b) ? c :     // 01 case (depends on c)
                 1'b0;              // 00 case
endmodule