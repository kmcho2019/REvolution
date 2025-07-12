module TopModule (
    input wire d,
    input wire ena,
    output reg q
);
    always @(ena) begin
        if (ena)
            q = d;  // latch is transparent when enable is high
        // else no assignment means q holds its previous value (latch inferred)
    end
endmodule