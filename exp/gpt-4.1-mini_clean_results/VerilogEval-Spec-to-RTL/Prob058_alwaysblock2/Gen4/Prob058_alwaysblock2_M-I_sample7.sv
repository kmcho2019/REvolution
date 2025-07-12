module TopModule(
    input  clk,
    input  a,
    input  b,
    output out_assign,
    output reg out_always_comb,
    output reg out_always_ff
);

    // Continuous assignment directly computes XOR
    assign out_assign = a ^ b;

    // Combinational block updates out_always_comb directly from inputs
    always @(*) begin
        out_always_comb = a ^ b;
    end

    // Sequential block registers XOR result at clock edge
    always @(posedge clk) begin
        out_always_ff <= a ^ b;
    end

endmodule