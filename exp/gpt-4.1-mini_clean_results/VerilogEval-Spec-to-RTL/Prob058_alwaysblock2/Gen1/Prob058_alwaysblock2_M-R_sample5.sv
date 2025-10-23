module TopModule (
    input  clk,
    input  a,
    input  b,
    output out_assign,
    output reg out_always_comb,
    output reg out_always_ff
);

    // Continuous assign statement for combinational XOR
    assign out_assign = a ^ b;

    // Combinational always block with explicit sensitivity list for XOR
    always @(a or b) begin
        out_always_comb = a ^ b;
    end

    // Clocked always block for registered XOR output
    always @(posedge clk) begin
        out_always_ff <= a ^ b;
    end

endmodule