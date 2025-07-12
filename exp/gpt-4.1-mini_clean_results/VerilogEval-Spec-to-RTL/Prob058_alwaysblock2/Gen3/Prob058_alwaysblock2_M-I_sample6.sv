module TopModule (
    input clk,
    input a,
    input b,
    output out_assign,
    output out_always_comb,
    output reg out_always_ff
);

    // Direct assign for combinational XOR output
    assign out_assign = a ^ b;

    // Replace combinational always block with continuous assign for better synthesis
    assign out_always_comb = a ^ b;

    // Sequential always block registers the XOR value on clock edge
    always @(posedge clk) begin
        out_always_ff <= a ^ b;
    end

endmodule