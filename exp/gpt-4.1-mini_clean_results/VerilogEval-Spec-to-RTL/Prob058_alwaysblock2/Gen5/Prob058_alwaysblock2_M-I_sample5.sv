module TopModule(
    input  clk,
    input  a,
    input  b,
    output out_assign,
    output reg out_always_comb,
    output reg out_always_ff
);

    // Continuous assignment for XOR output
    assign out_assign = a ^ b;

    // Combinational always block for XOR output
    always @(*) begin
        out_always_comb = a ^ b;
    end

    // Sequential always block for registered XOR output with synchronous reset
    // As no reset is specified, hold initial state at 0
    initial out_always_ff = 0;

    always @(posedge clk) begin
        out_always_ff <= a ^ b;
    end

endmodule