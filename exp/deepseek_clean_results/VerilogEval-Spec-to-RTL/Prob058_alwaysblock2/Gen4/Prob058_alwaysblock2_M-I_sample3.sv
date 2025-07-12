module TopModule (
    input clk,
    input a,
    input b,
    output out_assign,
    output reg out_always_comb,
    output reg out_always_ff
);

    assign out_assign = a ^ b;
    assign out_always_comb = out_assign;  // Reuse the assign output

    always @(posedge clk) begin
        out_always_ff <= a ^ b;  // Sequential path remains independent
    end

endmodule