module TopModule(
    input d,
    input ena,
    output reg q
);
    // Classic latch inference: blocking assignment in always block with incomplete assignment on q
    always @(ena or d) begin
        if (ena)
            q = d; // Transparent when ena=1
        // else q holds value implicitly (no assignment)
    end
endmodule