module TopModule(
    input clk,
    input a,
    input b,
    output out_assign,
    output out_always_comb,
    output reg out_always_ff
);

    reg prev_xor_result;
    reg xor_result;

    // Shared XOR operation in an always_comb block
    always_comb begin
        xor_result = a ^ b;
        out_assign = xor_result;
        out_always_comb = xor_result;
    end

    // Smart updating mechanism for out_always_ff
    always_ff @(posedge clk) begin
        if (xor_result != prev_xor_result) begin
            out_always_ff <= xor_result;
            prev_xor_result <= xor_result;
        end
    end

endmodule