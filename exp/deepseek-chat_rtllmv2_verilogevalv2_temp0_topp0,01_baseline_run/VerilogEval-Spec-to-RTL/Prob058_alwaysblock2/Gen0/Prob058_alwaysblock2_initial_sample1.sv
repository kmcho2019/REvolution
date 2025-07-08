module TopModule (
    input  clk,
    input  a,
    input  b,
    output out_assign,
    output out_always_comb,
    output out_always_ff
);

    // Continuous assignment for combinational XOR
    assign out_assign = a ^ b;

    // Combinational always block for XOR
    always_comb begin
        out_always_comb = a ^ b;
    end

    // Sequential always block for registered XOR
    always_ff @(posedge clk) begin
        out_always_ff <= a ^ b;
    end

endmodule