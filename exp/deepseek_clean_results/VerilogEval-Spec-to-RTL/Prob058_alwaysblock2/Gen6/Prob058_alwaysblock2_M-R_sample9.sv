module TopModule (
    input  clk,
    input  a,
    input  b,
    output out_assign,
    output out_always_comb,
    output out_always_ff
);

    // Continuous assignment for combinational logic
    assign out_assign = a ^ b;

    // Combinational always block directly assigning to output
    always_comb begin
        out_always_comb = a ^ b;
    end

    // Sequential always block with flip-flop
    reg out_ff_reg;
    always_ff @(posedge clk) begin
        out_ff_reg <= a ^ b;
    end

    // Connect flip-flop output to port
    assign out_always_ff = out_ff_reg;

endmodule