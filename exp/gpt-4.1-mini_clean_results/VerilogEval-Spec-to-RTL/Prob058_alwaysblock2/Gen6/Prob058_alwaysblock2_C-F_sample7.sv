module TopModule (
    input  clk,
    input  a,
    input  b,
    output out_assign,
    output reg out_always_comb,
    output reg out_always_ff
);

    // Shared internal wire for XOR of inputs a and b
    wire xor_res = a ^ b;

    // Continuous assignment drives out_assign directly from xor_res
    assign out_assign = xor_res;

    // Combinational always block assigns out_always_comb from xor_res
    always @(*) begin
        out_always_comb = xor_res;
    end

    // Sequential always block registers xor_res on rising edge of clk
    always @(posedge clk) begin
        out_always_ff <= xor_res;
    end

endmodule