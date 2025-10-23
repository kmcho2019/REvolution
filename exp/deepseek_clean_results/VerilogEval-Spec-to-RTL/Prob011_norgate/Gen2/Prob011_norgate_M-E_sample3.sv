module TopModule (
    input a,
    input b,
    output out
);
    // Implement NOR using a 4-to-1 mux
    // Truth table:
    // a b | out
    // 0 0 | 1
    // 0 1 | 0
    // 1 0 | 0
    // 1 1 | 0
    assign out = (a == 0 && b == 0) ? 1'b1 :
                 (a == 0 && b == 1) ? 1'b0 :
                 (a == 1 && b == 0) ? 1'b0 :
                 1'b0;  // a=1, b=1 case
endmodule