module TopModule(
    input  clk,
    input  a,
    input  b,
    output out_assign,
    output out_always_comb,
    output reg out_always_ff
);

    // Continuous assignments for out_assign and out_always_comb
    assign out_assign = a ^ b;
    assign out_always_comb = a ^ b;

    // Sequential always block for out_always_ff
    always @(posedge clk) begin
        out_always_ff <= a ^ b;
    end

endmodule