module TopModule (
    input  clk,
    input  a,
    input  b,
    output out_assign,
    output out_always_comb,
    output reg out_always_ff
);

    // Intermediate wire for XOR result
    wire xor_val = a ^ b;

    // Continuous assignments for combinational outputs
    assign out_assign = xor_val;
    assign out_always_comb = xor_val;

    // Sequential always block: register the XOR result on clock's rising edge
    always @(posedge clk) begin
        out_always_ff <= xor_val;
    end

endmodule