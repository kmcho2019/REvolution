module TopModule (
    input clk,
    input a,
    input b,
    output out_assign,
    output out_always_comb,
    output out_always_ff
);

    // Continuous assignment implementation
    assign out_assign = a ^ b;

    // Combinational always block implementation
    always @(*) begin
        out_always_comb = a ^ b;
    end

    // Clocked always block implementation (sequential logic)
    always @(posedge clk) begin
        out_always_ff <= a ^ b;
    end

endmodule