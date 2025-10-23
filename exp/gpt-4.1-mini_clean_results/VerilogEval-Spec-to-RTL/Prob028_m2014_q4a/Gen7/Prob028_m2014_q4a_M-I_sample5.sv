module TopModule (
    input  d,
    input  ena,
    output reg q
);

// D latch inferred by level-sensitive always block with blocking assignment
always @(ena or d) begin
    if (ena)
        q = d;   // Blocking assignment for latch transparency
    // else hold state implicitly by not assigning q
end

endmodule