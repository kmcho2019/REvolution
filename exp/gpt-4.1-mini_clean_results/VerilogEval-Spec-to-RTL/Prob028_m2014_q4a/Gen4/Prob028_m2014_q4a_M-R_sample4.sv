module TopModule (
    input  d,
    input  ena,
    output reg q
);

// Latch inferred by blocking assignment and no else branch
always @(ena or d) begin
    if (ena)
        q = d;  // Blocking assignment for level-sensitive latch
    // else no assignment: latch holds previous value
end

endmodule