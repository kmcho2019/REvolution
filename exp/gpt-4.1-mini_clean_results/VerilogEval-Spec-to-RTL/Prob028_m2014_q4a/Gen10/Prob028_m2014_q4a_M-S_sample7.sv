module TopModule(
    input wire d,
    input wire ena,
    output reg q
);

always @(*) begin
    if (ena)
        q = d;
    // else: no assignment, so q holds its previous value (latch inferred)
end

endmodule