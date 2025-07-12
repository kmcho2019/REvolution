module TopModule (
    input  wire clk,
    input  wire a,
    input  wire b,
    output wire out_assign,
    output wire out_always_comb,
    output reg  out_always_ff
);

    // Shared XOR computation (named for clarity)
    wire xor_ab = a ^ b;

    // Combinational outputs
    assign out_assign = xor_ab;
    assign out_always_comb = xor_ab;

    // Sequential output
    always @(posedge clk) begin
        out_always_ff <= xor_ab;
    end

endmodule