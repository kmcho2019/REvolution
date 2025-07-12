module TopModule (
    input  clk,
    input  a,
    input  b,
    output reg out_assign,
    output reg out_always_comb,
    output reg out_always_ff
);
    // Assign statement for out_assign
    assign out_assign = a ^ b;

    // Combinational always block for out_always_comb
    always_comb begin
        out_always_comb = a ^ b;
    end

    // Clocked always block for out_always_ff with clock gating
    reg clock_enable;
    assign clock_enable = 1'b1; // Clock enable is always on for simplicity
    always_ff @(posedge clk) begin
        if (clock_enable) begin
            out_always_ff <= a ^ b;
        end
    end
endmodule