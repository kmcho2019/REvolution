module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);
    // Priority-based implementation
    assign out = (~c & b) ? 1'b0 :       // Highest priority: c=0 and b=1 must be 0
                 (c & ~a & b) ? 1'b0 :    // Next priority: c=1, a=0, b=1 must be 0
                 (a | c) ? 1'b1 :         // Medium priority: a=1 or c=1 usually means 1
                 1'b0;                    // Default case (shouldn't occur with given K-map)
endmodule