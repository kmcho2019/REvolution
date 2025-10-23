module TopModule(
    input d,
    input ena,
    output reg q
);

    always @(d or ena) begin
        if (ena)
            q = d;  // Transparent latch: update q when enable is high
        // else q retains its previous value (latch inferred)
    end

endmodule