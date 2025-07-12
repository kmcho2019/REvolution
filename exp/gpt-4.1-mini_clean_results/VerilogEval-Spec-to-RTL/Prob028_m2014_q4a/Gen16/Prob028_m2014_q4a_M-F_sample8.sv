module TopModule(
    input  d,
    input  ena,
    output reg q
);

    // Latch implemented using level-sensitive always block on enable
    always @(ena or d) begin
        if (ena)
            q = d;
        // else no assignment: q holds its previous value (latch inferred)
    end

endmodule