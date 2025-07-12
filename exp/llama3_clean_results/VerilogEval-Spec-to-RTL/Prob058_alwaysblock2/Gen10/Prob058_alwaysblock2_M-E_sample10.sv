module TopModule #(
    parameter logic power_optimized = 1'b1,
    parameter logic performance_optimized = 1'b0,
    parameter logic area_optimized = 1'b0
) (
    input  clk,
    input  a,
    input  b,
    output out_assign,
    output out_always_comb,
    output reg out_always_ff
);

    // Assign statement for XOR gate
    assign out_assign = a ^ b;

    // Combinational always block for XOR gate using conditional operator
    always_comb begin
        out_always_comb = (a == b)? 1'b0 : 1'b1;
    end

    // Clocked always block with clock gating and input activity reduction
    reg clk_enable;
    always_comb begin
        clk_enable = (a!= b) && power_optimized;
    end

    always_ff @(posedge clk) begin
        if (clk_enable) begin
            out_always_ff <= a ^ b;
        end
    end

    // Optional area optimization by merging logic
    if (area_optimized) begin
        assign out_always_comb = out_assign;
    end
endmodule