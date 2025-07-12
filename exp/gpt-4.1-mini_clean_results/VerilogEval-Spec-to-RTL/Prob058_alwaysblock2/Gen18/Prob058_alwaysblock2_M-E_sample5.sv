module TopModule(
    input  clk,
    input  a,
    input  b,
    output out_assign,
    output reg out_always_comb,
    output reg out_always_ff
);

    // Direct assign: simple XOR of inputs
    assign out_assign = a ^ b;

    // Intermediate signals for combinational always block
    reg a_not, b_not;
    always @* begin
        a_not = ~a;
        b_not = ~b;
        // XOR implemented as (a & ~b) | (~a & b)
        out_always_comb = (a & b_not) | (a_not & b);
    end

    // Sequential block: registers whether inputs differ compared to previous inputs
    reg prev_a, prev_b;
    wire inputs_differ = (a ^ b);

    always @(posedge clk) begin
        prev_a <= a;
        prev_b <= b;
        // Register the current XOR (inputs_differ)
        out_always_ff <= inputs_differ;
    end

endmodule