module TopModule (
    input clk,
    input a,
    input b,
    output out_assign,
    output out_always_comb,
    output out_always_ff
);

    // Continuous assignment (combinational)
    assign out_assign = a ^ b;

    // Combinational always block
    always @(*) begin
        out_always_comb = a ^ b;
    end

    // Sequential always block (flip-flop)
    always @(posedge clk) begin
        out_always_ff <= a ^ b;
    end

endmodule