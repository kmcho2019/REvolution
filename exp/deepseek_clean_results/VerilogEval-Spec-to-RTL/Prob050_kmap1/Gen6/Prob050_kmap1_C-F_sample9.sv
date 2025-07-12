module TopModule (
    input a,
    input b,
    input c,
    output out
);
    // Truth table implementation:
    // abc | out
    // 000 | 0
    // 001 | 1
    // 010 | 1
    // 011 | 1
    // 100 | 1
    // 101 | 1
    // 110 | 1
    // 111 | 1
    
    // Minimal logic implementation (a OR b OR c)
    assign out = a | b | c;
endmodule