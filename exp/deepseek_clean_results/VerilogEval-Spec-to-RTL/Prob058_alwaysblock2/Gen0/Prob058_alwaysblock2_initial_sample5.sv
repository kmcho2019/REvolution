module TopModule (
    input clk,
    input a,
    input b,
    output out_assign,
    output out_always_comb,
    output out_always_ff
);

    // Continuous assignment (assign statement)
    assign out_assign = a ^ b;

    // Combinational always block
    always @(*) begin
        out_always_comb = a ^ b;
    end

    // Clocked always block (sequential logic)
    reg out_ff;
    always @(posedge clk) begin
        out_ff <= a ^ b;
    end
    assign out_always_ff = out_ff;

endmodule