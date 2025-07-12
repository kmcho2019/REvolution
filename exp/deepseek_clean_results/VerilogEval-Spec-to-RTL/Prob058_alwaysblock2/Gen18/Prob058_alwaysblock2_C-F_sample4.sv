module TopModule (
    input  clk,
    input  a,
    input  b,
    output wire out_assign,
    output wire out_always_comb,
    output reg  out_always_ff
);

    // Combinational logic - shared XOR operation
    wire xor_result = a ^ b;
    assign out_assign = xor_result;
    assign out_always_comb = xor_result;

    // Sequential logic
    always @(posedge clk) begin
        out_always_ff <= xor_result;
    end

endmodule