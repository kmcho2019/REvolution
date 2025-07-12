module TopModule (
    input  clk,
    input  a,
    input  b,
    output reg out_assign,
    output out_always_comb,
    output reg out_always_ff
);

    // Combinational logic using always block (formerly assign)
    always @(*) begin
        out_assign = a ^ b;
    end

    // Continuous assignment (formerly always comb)
    assign out_always_comb = a ^ b;

    // Sequential always block (unchanged)
    always @(posedge clk) begin
        out_always_ff <= a ^ b;
    end

endmodule