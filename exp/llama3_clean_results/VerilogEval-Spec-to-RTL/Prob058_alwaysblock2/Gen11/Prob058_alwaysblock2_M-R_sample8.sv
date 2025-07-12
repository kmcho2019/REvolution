// TopModule with optimized structure for PPA metrics
module TopModule (
    input  clk,
    input  a,
    input  b,
    output out_assign,
    output out_always_comb,
    output reg out_always_ff
);
    // Continuous assignment for XOR operation
    assign out_assign = a ^ b;

    // Combinational always block for XOR operation
    always_comb begin
        out_always_comb = a ^ b;
    end

    // Clocked always block with potential for clock gating
    reg prev_a, prev_b; // Registers to store previous values of a and b
    always_ff @(posedge clk) begin
        // Simple form of input activity reduction: only update out_always_ff if inputs change
        if (a !== prev_a || b !== prev_b) begin
            out_always_ff <= a ^ b;
            prev_a <= a;
            prev_b <= b;
        end
    end
endmodule