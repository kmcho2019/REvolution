module TopModule (
    input  clk,
    input  a,
    input  b,
    output       out_assign,
    output reg   out_always_comb,
    output reg   out_always_ff
);

    wire xor_val = a ^ b;

    // Continuous assignment for combinational XOR output
    assign out_assign = xor_val;

    // Combinational always block for out_always_comb
    always @(*) begin
        out_always_comb = xor_val;
    end

    // Sequential always block: register XOR result on rising clock edge
    always @(posedge clk) begin
        out_always_ff <= xor_val;
    end

endmodule