module TopModule #(
    parameter WIDTH = 4
)(
    input  [WIDTH-1:0] in,
    output reg         out_and,
    output reg         out_or,
    output reg         out_xor
);

    // Combinational block updates outputs on any input change.
    // The outputs represent AND, OR, and XOR reductions over the input bits.
    // Using an always block with sensitivity to all inputs (*) for combinational logic.
    //
    // This alternative implementation differs from continuous assignments by explicitly declaring outputs as regs
    // and updating them procedurally, but the logic and timing remain equivalent and optimal.

    always @(*) begin
        out_and = &in;  // reduction AND
        out_or  = |in;  // reduction OR
        out_xor = ^in;  // reduction XOR
    end

endmodule