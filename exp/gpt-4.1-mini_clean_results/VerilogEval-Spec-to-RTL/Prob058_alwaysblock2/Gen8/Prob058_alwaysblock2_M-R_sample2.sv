module TopModule(
    input  clk,
    input  a,
    input  b,
    output out_assign,
    output reg out_always_comb,
    output reg out_always_ff
);

    // Intermediate wire to hold XOR of inputs
    wire xor_ab;
    assign xor_ab = a ^ b;

    // Continuous assignment output directly driven by xor_ab
    assign out_assign = xor_ab;

    // Combinational always block driven by xor_ab
    always @(*) begin
        out_always_comb = xor_ab;
    end

    // Sequential always block registering xor_ab on positive clock edge
    always @(posedge clk) begin
        out_always_ff <= xor_ab;
    end

endmodule