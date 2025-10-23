module TopModule(
    input  clk,
    input  a,
    input  b,
    output out_assign,
    output reg out_always_comb,
    output reg out_always_ff
);

    // Continuous assignment for XOR
    assign out_assign = a ^ b;

    // Combinational always block computing XOR internally
    always @(*) begin
        out_always_comb = a ^ b;
    end

    // Sequential always block computing XOR internally and storing in flip-flop
    always @(posedge clk) begin
        out_always_ff <= a ^ b;
    end

endmodule