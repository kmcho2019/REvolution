module TopModule(
    input  clk,
    input  a,
    input  b,
    output out_assign,
    output reg out_always_comb,
    output reg out_always_ff
);

    // Compute XOR once in a wire
    wire xor_result = a ^ b;

    // Continuous assignment for out_assign
    assign out_assign = xor_result;

    // Combinational always block drives out_always_comb from xor_result
    always @(*) begin
        out_always_comb = xor_result;
    end

    // Sequential always block for registered output
    always @(posedge clk) begin
        out_always_ff <= xor_result;
    end

endmodule