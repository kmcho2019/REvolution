module TopModule (
    input clk, a, b,
    output out_assign,
    output out_always_comb,
    output reg out_always_ff
);

    // Shared XOR computation
    wire xor_result = a ^ b;
    
    // Combinational outputs
    assign out_assign = xor_result;
    assign out_always_comb = xor_result;
    
    // Sequential output with input change detection
    reg [1:0] prev_inputs;
    always @(posedge clk) begin
        prev_inputs <= {a, b};
        if (prev_inputs != {a, b}) begin  // Only update when inputs change
            out_always_ff <= xor_result;
        end
    end

endmodule