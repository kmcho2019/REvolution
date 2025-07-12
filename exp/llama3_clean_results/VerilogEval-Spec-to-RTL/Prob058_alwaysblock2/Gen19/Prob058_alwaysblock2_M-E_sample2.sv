module TopModule(
    input clk,
    input a,
    input b,
    input mode,
    output out_assign,
    output out_always_comb,
    output out_always_ff
);

    // Internal signals
    wire comb_xor;
    reg seq_xor;

    // Combinational XOR
    assign comb_xor = a ^ b;

    // Sequential XOR (flip-flop)
    always_ff @(posedge clk) begin
        seq_xor <= a ^ b;
    end

    // Direct assign for out_assign
    assign out_assign = a ^ b;

    // MUX for out_always_comb and out_always_ff based on mode
    assign out_always_comb = (mode == 0) ? comb_xor : seq_xor;
    assign out_always_ff = seq_xor;

endmodule