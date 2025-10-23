module TopModule (
    input clk,
    input a,
    input b,
    output out_assign,
    output reg out_always_comb,
    output reg out_always_ff
);

    // Shared internal wire for XOR of inputs a and b
    wire xor_res = a ^ b;

    // Continuous assign drives combinational output directly from xor_res
    assign out_assign = xor_res;

    // Combinational always block driven from shared xor_res
    always @(*) begin
        out_always_comb = xor_res;
    end

    // Sequential always block registers xor_res on positive clock edge
    always @(posedge clk) begin
        out_always_ff <= xor_res;
    end

endmodule