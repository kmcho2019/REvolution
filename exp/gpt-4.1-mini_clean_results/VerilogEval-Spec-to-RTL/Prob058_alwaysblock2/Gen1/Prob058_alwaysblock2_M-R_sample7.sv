module TopModule(
    input  clk,
    input  a,
    input  b,
    output out_assign,
    output reg out_always_comb,
    output reg out_always_ff
);

    // Intermediate wire holds XOR of a and b
    wire xor_val = a ^ b;

    // Continuous assignment directly from xor_val
    assign out_assign = xor_val;

    // Combinational block updates out_always_comb from xor_val
    always @(*) begin
        out_always_comb = xor_val;
    end

    // Sequential block registers xor_val at clock edge for delayed output
    always @(posedge clk) begin
        out_always_ff <= xor_val;
    end

endmodule