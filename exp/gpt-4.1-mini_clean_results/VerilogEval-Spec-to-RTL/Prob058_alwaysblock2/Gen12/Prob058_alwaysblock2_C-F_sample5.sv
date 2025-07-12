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

    // Sequential always block for out_always_ff
    always @(posedge clk) begin
        out_always_ff <= xor_val;
    end

endmodule