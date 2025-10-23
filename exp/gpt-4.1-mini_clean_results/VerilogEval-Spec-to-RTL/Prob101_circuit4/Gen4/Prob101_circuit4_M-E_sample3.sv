module TopModule(
    input a,
    input b,
    input c,
    input d,
    output reg q
);

    // Intermediate signals for inversion
    wire nb, nc;
    assign nb = ~b;
    assign nc = ~c;

    always @(*) begin
        // q is NAND of nb and nc: q = ~(nb & nc) = b | c
        q = ~(nb & nc);
    end

endmodule