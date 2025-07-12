module TopModule(
    input d,
    input ena,
    output reg q
);

    always @(d or ena) begin
        if (ena)
            q = d; // Transparent when enable is high
        // else q holds its previous value (no assignment)
    end

endmodule