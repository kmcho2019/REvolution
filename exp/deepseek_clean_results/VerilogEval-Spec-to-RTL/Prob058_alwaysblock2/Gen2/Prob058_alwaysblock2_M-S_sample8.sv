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
    assign out_always_comb = a ^ b;  // Simplified combinational output

    // Clocked always block (sequential logic)
    reg out_always_ff;
    always @(posedge clk) begin
        out_always_ff <= a ^ b;
    end

endmodule