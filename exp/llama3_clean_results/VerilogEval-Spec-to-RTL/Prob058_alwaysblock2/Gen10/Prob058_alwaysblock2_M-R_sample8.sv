// TopModule implementing XOR gate in three ways
module TopModule(
    input  clk,
    input  a,
    input  b,
    output out_assign,
    output out_always_comb,
    output reg out_always_ff
);
    // Continuous assignment
    assign out_assign = a ^ b;

    // Direct assignment for combinational logic (replaces always_comb)
    assign out_always_comb = a ^ b;

    // Clocked always block for flip-flop output
    always_ff @(posedge clk) begin
        out_always_ff <= a ^ b;
    end
endmodule