module TopModule #(
    parameter USE_NAND_IMPL = 0  // 0: use direct XOR/AND, 1: use NAND-only implementation
) (
    input  wire a,
    input  wire b,
    output wire sum,
    output wire cout
);

generate
    if (USE_NAND_IMPL) begin : nand_impl
        // Intermediate NAND wires
        wire nand_ab;
        wire nand_a_nand_ab;
        wire nand_b_nand_ab;

        // NAND gate implementations
        assign nand_ab         = ~(a & b);
        assign nand_a_nand_ab  = ~(a & nand_ab);
        assign nand_b_nand_ab  = ~(b & nand_ab);

        // sum = a XOR b implemented via NAND gates
        assign sum  = ~(nand_a_nand_ab & nand_b_nand_ab);
        // cout = a AND b implemented via NAND gates
        assign cout = ~(nand_ab & nand_ab);
    end else begin : direct_impl
        // Direct use of XOR and AND primitives for optimal PPA
        xor (sum, a, b);
        and (cout, a, b);
    end
endgenerate

endmodule