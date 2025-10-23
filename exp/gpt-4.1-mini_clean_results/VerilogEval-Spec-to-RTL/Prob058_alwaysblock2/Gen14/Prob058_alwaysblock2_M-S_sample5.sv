module TopModule(
    input  clk,
    input  a,
    input  b,
    output out_assign,
    output out_always_comb,
    output reg out_always_ff
);

    // Shared combinational XOR output
    assign out_assign = a ^ b;
    assign out_always_comb = out_assign;

    // Sequential logic: register the XOR result at clock edge
    always @(posedge clk) begin
        out_always_ff <= a ^ b;
    end

endmodule