module TopModule(
    input d,
    input ena,
    output reg q
);

// Transparent mode: when ena=1, q follows d
always @(ena or d) begin
    if (ena)
        q = d;
end

// Hold mode: when ena=0, q holds its previous value (do nothing)
// This block triggers on ena changes to clarify latch behavior
always @(ena) begin
    if (!ena)
        q = q; // explicitly hold q (no change)
end

endmodule