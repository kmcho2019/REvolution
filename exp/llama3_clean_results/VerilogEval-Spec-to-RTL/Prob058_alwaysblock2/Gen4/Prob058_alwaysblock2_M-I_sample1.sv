// Improved TopModule with merged XOR operations
module TopModule (
    input  clk,
    input  a,
    input  b,
    output out_assign,
    output out_always_comb,
    output reg out_always_ff
);
    // Using assign statement for out_assign
    assign out_assign = a ^ b;

    // Using always_comb for out_always_comb
    always_comb begin
        out_always_comb = a ^ b;
    end

    // Using always_ff for out_always_ff with non-blocking assignment
    always_ff @(posedge clk) begin
        out_always_ff <= a ^ b;
    end
endmodule