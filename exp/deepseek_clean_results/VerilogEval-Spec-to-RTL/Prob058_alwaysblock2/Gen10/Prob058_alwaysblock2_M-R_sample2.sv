module TopModule (
    input  wire clk,
    input  wire a,
    input  wire b,
    output wire out_assign,
    output wire out_always_comb,
    output reg  out_always_ff
);

    // Combined combinational outputs
    assign {out_assign, out_always_comb} = {a ^ b, a ^ b};

    // Sequential output with direct XOR computation
    always @(posedge clk) begin
        out_always_ff <= a ^ b;
    end

endmodule