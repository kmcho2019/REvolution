module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);
    wire case_c1 = a | b;  // When c=1, output 1 unless a=0 and b=0
    wire case_c0 = a & b;  // When c=0, output 1 only when a=1 and b=1
    
    assign out = c ? case_c1 : case_c0;
endmodule