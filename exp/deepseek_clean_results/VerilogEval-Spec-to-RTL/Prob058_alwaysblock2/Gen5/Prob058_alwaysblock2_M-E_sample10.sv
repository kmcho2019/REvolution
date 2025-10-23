module TopModule (
    input clk,
    input a,
    input b,
    output out_assign,
    output out_always_comb,
    output out_always_ff
);

    // Shared combinational logic
    reg comb_xor;
    always @(*) begin
        case ({a, b})
            2'b00: comb_xor = 1'b0;
            2'b01: comb_xor = 1'b1;
            2'b10: comb_xor = 1'b1;
            2'b11: comb_xor = 1'b0;
            default: comb_xor = 1'b0;
        endcase
    end

    assign out_assign = comb_xor;
    assign out_always_comb = comb_xor;

    // Two-stage pipelined implementation
    reg stage1_a, stage1_b;
    reg stage2_xor;

    always @(posedge clk) begin
        // Stage 1: Register inputs
        stage1_a <= a;
        stage1_b <= b;
        
        // Stage 2: Compute XOR
        stage2_xor <= stage1_a ^ stage1_b;
    end

    assign out_always_ff = stage2_xor;

endmodule