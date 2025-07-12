module TopModule (
    input  d,
    input  ena,
    output reg q
);

// Explicit sensitivity list including enable and data
always @(ena or d) begin
    if (ena)
        q <= d;  // Nonblocking assignment suitable for sequential style
    // else branch omitted to infer latch: q holds previous state
end

endmodule