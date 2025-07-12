module TopModule (
    input  d,
    input  ena,
    output q
);

reg q_reg;

// Latch inferred by blocking assignment and no else branch
always @(ena or d) begin
    if (ena)
        q_reg = d;
    // else retain previous q_reg
end

assign q = q_reg;

endmodule