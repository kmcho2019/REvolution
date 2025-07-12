module TopModule (
    input  clk,
    input  a,
    input  b,
    output out_assign,
    output out_always_comb,
    output out_always_ff
);

    // Internal reg declarations for procedural assignments
    reg out_comb_reg;
    reg out_ff_reg;

    // Continuous assignment for combinational logic
    assign out_assign = a ^ b;

    // Combinational always block using internal reg
    always_comb begin
        out_comb_reg = a ^ b;
    end

    // Connect internal reg to output port
    assign out_always_comb = out_comb_reg;

    // Sequential always block with flip-flop using internal reg
    always_ff @(posedge clk) begin
        out_ff_reg <= a ^ b;
    end

    // Connect internal reg to output port
    assign out_always_ff = out_ff_reg;

endmodule