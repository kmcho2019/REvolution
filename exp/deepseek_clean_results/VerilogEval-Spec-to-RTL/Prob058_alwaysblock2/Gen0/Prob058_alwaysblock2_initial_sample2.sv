module TopModule (
    input clk,
    input a,
    input b,
    output out_assign,
    output out_always_comb,
    output out_always_ff
);

    // Continuous assignment for XOR
    assign out_assign = a ^ b;

    // Combinational always block for XOR
    always @(*) begin
        out_always_comb = a ^ b;
    end

    // Sequential always block for XOR (registered output)
    always @(posedge clk) begin
        out_always_ff <= a ^ b;
    end

endmodule