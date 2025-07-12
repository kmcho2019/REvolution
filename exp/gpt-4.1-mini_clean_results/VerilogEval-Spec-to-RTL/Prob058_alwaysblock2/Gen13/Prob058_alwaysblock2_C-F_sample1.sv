module TopModule(
    input  clk,
    input  a,
    input  b,
    output out_assign,
    output reg out_always_comb,
    output reg out_always_ff
);

    // Intermediate wire for XOR computation
    wire xor_result = a ^ b;

    // Continuous assignment output
    assign out_assign = xor_result;

    // Combinational always block output
    always @(*) begin
        out_always_comb = xor_result;
    end

    // Sequential always block output, registered on positive edge of clk
    always @(posedge clk) begin
        out_always_ff <= xor_result;
    end

endmodule