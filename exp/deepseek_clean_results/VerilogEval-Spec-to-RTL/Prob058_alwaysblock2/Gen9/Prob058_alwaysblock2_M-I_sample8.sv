module TopModule (
    input  wire clk,
    input  wire a,
    input  wire b,
    output wire out_assign,
    output wire out_always_comb,
    output reg  out_always_ff
);

    // Single shared XOR computation
    wire xor_ab = a ^ b;

    // All combinational outputs share the same XOR result
    assign out_assign       = xor_ab;
    assign out_always_comb  = xor_ab;

    // Sequential output with clean flip-flop
    always @(posedge clk) begin
        out_always_ff <= xor_ab;
    end

endmodule