module TopModule (
    input  d,
    input  ena,
    output reg q
);

// Latch inferred by blocking assignment and sensitivity list on ena and d
always @(ena or d) begin
    if (ena)
        q = d;  // Blocking assignment to infer transparent latch
    // else no assignment: latch holds previous value
end

endmodule