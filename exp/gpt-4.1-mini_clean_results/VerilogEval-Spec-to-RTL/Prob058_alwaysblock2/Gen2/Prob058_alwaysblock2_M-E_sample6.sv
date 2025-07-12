module TopModule(
    input  clk,
    input  a,
    input  b,
    output out_assign,
    output reg out_always_comb,
    output reg out_always_ff
);

    // Direct continuous assignment computes XOR for out_assign
    assign out_assign = a ^ b;

    // Combinational always block with blocking assignment to out_always_comb
    always @(a or b) begin
        out_always_comb = a ^ b;
    end

    // Sequential always block with non-blocking assignment to out_always_ff
    always @(posedge clk) begin
        out_always_ff <= a ^ b;
    end

endmodule