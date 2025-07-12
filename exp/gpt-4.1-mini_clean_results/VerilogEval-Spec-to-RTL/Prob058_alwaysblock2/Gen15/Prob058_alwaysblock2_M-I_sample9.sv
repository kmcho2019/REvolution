module TopModule(
    input  clk,
    input  a,
    input  b,
    output out_assign,
    output out_always_comb,
    output reg out_always_ff
);

    // Internal wire to hold combinational XOR result
    wire xor_val = a ^ b;

    // Drive combinational outputs from the same XOR wire
    assign out_assign = xor_val;
    assign out_always_comb = xor_val;

    // Sequential logic: register the XOR result at clock edge
    always @(posedge clk) begin
        out_always_ff <= xor_val;
    end

endmodule