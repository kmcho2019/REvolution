module TopModule(
    input a,
    input b,
    output sum,
    output cout
);
    // 4-to-1 MUX implementation for sum
    // Input combinations:
    // 00 -> 0 (sum when a=0, b=0)
    // 01 -> 1 (sum when a=0, b=1)
    // 10 -> 1 (sum when a=1, b=0)
    // 11 -> 0 (sum when a=1, b=1)
    assign sum = (~a & ~b) ? 1'b0 :
                (~a &  b) ? 1'b1 :
                ( a & ~b) ? 1'b1 :
                             1'b0;

    // 4-to-1 MUX implementation for cout
    // Input combinations:
    // 00 -> 0 (cout when a=0, b=0)
    // 01 -> 0 (cout when a=0, b=1)
    // 10 -> 0 (cout when a=1, b=0)
    // 11 -> 1 (cout when a=1, b=1)
    assign cout = (~a & ~b) ? 1'b0 :
                  (~a &  b) ? 1'b0 :
                  ( a & ~b) ? 1'b0 :
                               1'b1;
endmodule