module TopModule(
    input  clk,
    input  a,
    input  b,
    output out_assign,
    output reg out_always_comb,
    output reg out_always_ff
);

    wire xor_result;

    // Compute XOR once
    assign xor_result = a ^ b;

    // Continuous assignment for XOR output
    assign out_assign = xor_result;

    // Combinational always block using the intermediate wire
    always @(*) begin
        out_always_comb = xor_result;
    end

    // Sequential always block registers the intermediate wire
    always @(posedge clk) begin
        out_always_ff <= xor_result;
    end

endmodule