module TopModule (
    input  clk,
    input  a,
    input  b,
    output out_assign,
    output out_always_comb,
    output reg out_always_ff
);

    // Shared XOR computation for combinational outputs
    wire xor_ab = a ^ b;

    // Combinational outputs
    assign out_assign = xor_ab;
    assign out_always_comb = xor_ab;

    // Sequential output (clocked behavior)
    always @(posedge clk) begin
        out_always_ff <= a ^ b;
    end

endmodule