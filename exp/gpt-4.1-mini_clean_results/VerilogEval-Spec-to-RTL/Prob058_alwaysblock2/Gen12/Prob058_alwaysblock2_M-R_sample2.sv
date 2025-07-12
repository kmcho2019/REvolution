module TopModule(
    input  clk,
    input  a,
    input  b,
    output out_assign,
    output reg out_always_comb,
    output reg out_always_ff
);

    // Intermediate wire for XOR result
    wire xor_val;
    assign xor_val = a ^ b;

    // Continuous assignment for out_assign using xor_val
    assign out_assign = xor_val;

    // Combinational always block for out_always_comb using xor_val
    always @(*) begin
        out_always_comb = xor_val;
    end

    // Sequential always block for out_always_ff registering xor_val
    always @(posedge clk) begin
        out_always_ff <= xor_val;
    end

endmodule