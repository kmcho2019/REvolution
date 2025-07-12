module TopModule(
    input clk,
    input a,
    input b,
    output out_assign,
    output out_always_comb,
    output reg out_always_ff
);

    // Shared combinational logic block for XOR operation
    wire xor_result;
    assign xor_result = a ^ b;

    // Drive out_assign and out_always_comb from the shared XOR result
    assign out_assign = xor_result;
    assign out_always_comb = xor_result;

    // Novel approach using a MUX for out_always_ff
    reg prev_xor_result;
    always_ff @(posedge clk) begin
        prev_xor_result <= xor_result;
        out_always_ff <= prev_xor_result;
    end

    // Alternatively, the MUX can be explicitly instantiated
    // but the above implementation using a simple reg is more efficient

endmodule