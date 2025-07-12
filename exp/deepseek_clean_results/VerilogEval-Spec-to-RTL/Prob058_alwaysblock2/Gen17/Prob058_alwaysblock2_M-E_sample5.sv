module TopModule (
    input clk,
    input a,
    input b,
    output wire out_assign,
    output wire out_always_comb,
    output reg out_always_ff
);

    // Shared XOR computation
    wire xor_result = a ^ b;
    
    // Combinational outputs
    assign out_assign = xor_result;
    assign out_always_comb = xor_result;
    
    // Efficient sequential implementation using toggle flip-flop
    reg last_xor;
    always @(posedge clk) begin
        last_xor <= xor_result;
        if (xor_result != last_xor) begin
            out_always_ff <= xor_result;
        end
    end

endmodule