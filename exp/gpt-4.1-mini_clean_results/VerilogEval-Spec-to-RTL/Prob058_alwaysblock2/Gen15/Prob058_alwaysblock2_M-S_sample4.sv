module TopModule(
    input  clk,
    input  a,
    input  b,
    output out_assign,
    output reg out_always_comb,
    output reg out_always_ff
);

    assign out_assign = a ^ b;

    always @(posedge clk or a or b) begin
        out_always_comb = a ^ b;
        if (clk) out_always_ff <= a ^ b;
    end

endmodule