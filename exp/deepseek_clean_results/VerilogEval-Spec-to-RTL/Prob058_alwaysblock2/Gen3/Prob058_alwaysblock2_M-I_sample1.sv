module TopModule (
    input clk,
    input a,
    input b,
    output out_assign,
    output reg out_always_comb,
    output reg out_always_ff
);

    // Continuous assignment (combinational) - remains optimal
    assign out_assign = a ^ b;

    // Combinational always block - remains optimal
    always @(*) begin
        out_always_comb = a ^ b;
    end

    // Sequential always block with synchronous reset
    always @(posedge clk) begin
        out_always_ff <= a ^ b;
    end

endmodule