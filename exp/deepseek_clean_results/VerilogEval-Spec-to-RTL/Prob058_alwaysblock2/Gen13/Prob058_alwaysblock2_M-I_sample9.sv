module TopModule (
    input  wire clk,
    input  wire a,
    input  wire b,
    output wire out_assign,
    output wire out_always_comb,
    output reg  out_always_ff
);

    // Combinational outputs share the same XOR computation
    wire xor_ab = a ^ b;
    assign out_assign = xor_ab;
    assign out_always_comb = xor_ab;

    // Sequential output computes XOR directly to optimize routing
    always @(posedge clk) begin
        out_always_ff <= a ^ b;
    end

endmodule