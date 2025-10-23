module TopModule(
    input d,
    input ena,
    output reg q
);
    // Sensitive to ena and d explicitly to infer latch
    always @(ena or d) begin
        if (ena)
            q = d;
        // else q retains its previous value (no assignment)
    end
endmodule