module TopModule (
    input  wire clk,
    input  wire a,
    input  wire b,
    output wire out_assign,
    output wire out_always_comb,
    output reg  out_always_ff
);

    // Shared XOR computation for combinational outputs
    wire xor_ab = a ^ b;
    assign out_assign = xor_ab;
    assign out_always_comb = xor_ab;

    // Sequential output with direct XOR computation
    always @(posedge clk) begin
        out_always_ff <= xor_ab;
    end

endmodule