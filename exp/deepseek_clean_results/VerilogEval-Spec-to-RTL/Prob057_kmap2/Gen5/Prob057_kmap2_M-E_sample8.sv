module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

wire condition1 = c & d & ~a & ~b;      // 1100
wire condition2 = ~c & ~d & a & b;      // 0011
wire condition3 = c & ~d & a & b;       // 1011
wire condition4 = ~c & d & ~a & b;      // 0101
wire condition5 = c & ~d & a & ~b;      // 1010

assign out = ~(condition1 | condition2 | condition3 | condition4 | condition5);

endmodule