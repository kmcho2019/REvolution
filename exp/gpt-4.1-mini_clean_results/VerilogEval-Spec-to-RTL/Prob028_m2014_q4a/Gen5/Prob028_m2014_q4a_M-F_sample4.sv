module TopModule (
    input  d,
    input  ena,
    output reg q
);

// Initialize q to 0 for simulation clarity; synthesis tools typically ignore this
initial q = 1'b0;

// Latch inferred by blocking assignment and no else branch
always @* begin
    if (ena)
        q = d;  // Blocking assignment for level-sensitive latch
    // else: q holds previous value implicitly (latch)
end

endmodule