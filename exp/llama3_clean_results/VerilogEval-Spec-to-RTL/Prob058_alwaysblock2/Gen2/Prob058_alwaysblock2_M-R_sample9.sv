// TopModule implementation with refactored structure
module TopModule(
    input clk,
    input a,
    input b,
    output out_assign,
    output out_always_comb,
    output reg out_always_ff
);

    // Use assign statement for out_assign
    assign out_assign = a ^ b;

    // Use assign statement for out_always_comb
    assign out_always_comb = a ^ b;

    // Use always block for out_always_ff
    always @(posedge clk) begin
        out_always_ff <= a ^ b;
    end

endmodule