module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);
    assign out = (~c & ~d & ~(a & b)) |  // Top-left quadrant
                 (~c & d & (~a | ~b)) |   // Top-right pair
                 (c & d & (a | b)) |      // Middle-right square
                 (c & ~d & (~a | b));     // Bottom-left L-shape
endmodule