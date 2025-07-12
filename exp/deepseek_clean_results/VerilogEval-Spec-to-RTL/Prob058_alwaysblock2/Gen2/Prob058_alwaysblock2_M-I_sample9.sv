module TopModule (
    input  clk,
    input  a,
    input  b,
    output out_assign,
    output out_always_comb,
    output out_always_ff
);

    // Only need one internal reg for the sequential output
    reg out_ff_reg;

    // Continuous assignment remains the same (most efficient)
    assign out_assign = a ^ b;

    // Combinational always block with direct output assignment
    always_comb begin
        out_always_comb = a ^ b;
    end

    // Sequential always block with flip-flop
    always_ff @(posedge clk) begin
        out_ff_reg <= a ^ b;
    end

    // Direct connection for sequential output
    assign out_always_ff = out_ff_reg;

endmodule