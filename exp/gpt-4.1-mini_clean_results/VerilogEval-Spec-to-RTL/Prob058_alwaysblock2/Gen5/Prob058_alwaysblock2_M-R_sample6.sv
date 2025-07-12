module TopModule(
    input  clk,
    input  a,
    input  b,
    output out_assign,
    output reg out_always_comb,
    output reg out_always_ff
);

    // Direct continuous assignment of XOR to out_assign
    assign out_assign = a ^ b;

    // Combinational always block calculates XOR directly from inputs
    always @(*) begin
        out_always_comb = a ^ b;
    end

    // Sequential always block registers XOR at posedge clk
    always @(posedge clk) begin
        out_always_ff <= a ^ b;
    end

endmodule