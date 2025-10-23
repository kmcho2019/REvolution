module TopModule(
    input  clk,
    input  a,
    input  b,
    output out_assign,
    output reg out_always_comb,
    output reg out_always_ff
);

    // Compute XOR once to share among outputs
    wire xor_val = a ^ b;

    // Continuous assignment for out_assign
    assign out_assign = xor_val;

    // Combinational always block for out_always_comb
    always @(*) begin
        out_always_comb = xor_val;
    end

    // Clock gating: enable flip-flop only if xor_val changes to save power
    reg xor_val_d;
    wire clk_en = (xor_val != xor_val_d);

    always @(posedge clk) begin
        xor_val_d <= xor_val;
        if (clk_en)
            out_always_ff <= xor_val;
    end

endmodule