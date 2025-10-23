module TopModule(
    input  clk,
    input  a,
    input  b,
    output out_assign,
    output reg out_always_comb,
    output reg out_always_ff
);

    wire xor_val = a ^ b;

    // Continuous assignment for out_assign
    assign out_assign = xor_val;

    // Combinational always block for out_always_comb
    always @(*) begin
        out_always_comb = xor_val;
    end

    // Clock gating: enable flip-flop update only when xor_val changes
    reg prev_xor_val;
    wire clk_en = (xor_val != prev_xor_val);

    // Gated clock generation
    wire gated_clk = clk & clk_en;

    always @(posedge clk) begin
        prev_xor_val <= xor_val;
    end

    // Sequential always block triggered on gated clock
    always @(posedge gated_clk) begin
        out_always_ff <= xor_val;
    end

endmodule