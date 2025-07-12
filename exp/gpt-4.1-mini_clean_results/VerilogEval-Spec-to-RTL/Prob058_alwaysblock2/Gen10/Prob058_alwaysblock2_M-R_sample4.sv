module TopModule (
    input  clk,
    input  a,
    input  b,
    output out_assign,
    output reg out_always_comb,
    output reg out_always_ff
);

    // Continuous assignment for out_assign directly
    assign out_assign = a ^ b;

    // Combinational always block for out_always_comb computing XOR explicitly
    always @(*) begin
        out_always_comb = a ^ b;
    end

    // Sequential always block for out_always_ff registering XOR on posedge clk
    always @(posedge clk) begin
        out_always_ff <= a ^ b;
    end

endmodule