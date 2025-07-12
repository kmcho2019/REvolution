module TopModule (
    input  clk,
    input  a,
    input  b,
    output       out_assign,
    output reg   out_always_comb,
    output reg   out_always_ff
);

    // Intermediate wire for XOR result
    wire xor_val = a ^ b;

    // Continuous assignment for combinational output (assign statement)
    assign out_assign = xor_val;

    // Combinational always block to drive out_always_comb
    always_comb begin
        out_always_comb = xor_val;
    end

    // Sequential always block: register the XOR result on clock's rising edge
    always @(posedge clk) begin
        out_always_ff <= xor_val;
    end

endmodule