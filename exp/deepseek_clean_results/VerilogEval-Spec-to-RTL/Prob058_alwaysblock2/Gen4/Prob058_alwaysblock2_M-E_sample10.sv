module TopModule (
    input  clk,
    input  a,
    input  b,
    output out_assign,
    output out_always_comb,
    output reg out_always_ff
);

    // Standard XOR implementation
    assign out_assign = a ^ b;

    // Decomposed XOR implementation (A'B + AB')
    always_comb begin
        out_always_comb = (~a & b) | (a & ~b);
    end

    // Toggle flip-flop implementation of XOR
    always_ff @(posedge clk) begin
        if (a != b) begin
            out_always_ff <= ~out_always_ff;
        end
    end

endmodule