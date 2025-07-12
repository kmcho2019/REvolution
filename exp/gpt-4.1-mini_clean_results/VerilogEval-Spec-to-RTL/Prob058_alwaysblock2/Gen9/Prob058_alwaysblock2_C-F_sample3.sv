module TopModule (
    input  clk,
    input  a,
    input  b,
    output out_assign,
    output reg out_always_comb,
    output reg out_always_ff
);

    // Single XOR gate output as internal wire
    wire xor_comb = a ^ b;

    // Continuous assignment for out_assign
    assign out_assign = xor_comb;

    // Combinational always block for out_always_comb
    always @(*) begin
        out_always_comb = xor_comb;
    end

    // Sequential always block for out_always_ff (registered output)
    always @(posedge clk) begin
        out_always_ff <= xor_comb;
    end

endmodule