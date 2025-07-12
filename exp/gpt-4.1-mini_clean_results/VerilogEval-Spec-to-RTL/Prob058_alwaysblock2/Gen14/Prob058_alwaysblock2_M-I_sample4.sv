module TopModule(
    input  clk,
    input  a,
    input  b,
    output out_assign,
    output reg out_always_comb,
    output reg out_always_ff
);

    wire xor_out;
    assign xor_out = a ^ b;

    // Continuous assignment for out_assign
    assign out_assign = xor_out;

    // Combinational always block for out_always_comb
    always @(*) begin
        out_always_comb = xor_out;
    end

    // Sequential always block for out_always_ff
    always @(posedge clk) begin
        out_always_ff <= xor_out;
    end

endmodule