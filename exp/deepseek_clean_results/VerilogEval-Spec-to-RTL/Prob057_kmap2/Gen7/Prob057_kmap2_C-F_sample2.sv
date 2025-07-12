module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

assign out = (~c & ~d & (a | ~b)) |  // Top-left quadrant
             (~c & d & ~b) |         // Middle-left column
             (c & ~d & a) |           // Right-center column
             (c & d & (b | ~a));      // Bottom-right quadrant

endmodule