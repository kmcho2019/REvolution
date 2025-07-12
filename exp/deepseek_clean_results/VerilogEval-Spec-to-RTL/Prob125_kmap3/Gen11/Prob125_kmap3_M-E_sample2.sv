module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);
    // Priority structure:
    // 1. If c=1 and b=0, output 1
    // 2. Else if c=1, output a
    // 3. Else output (a & (b | ~b)) which simplifies to a
    // The don't-cares allow us to merge some cases
    assign out = (c & ~b) ? 1'b1 : 
                (c) ? a : 
                a;
endmodule