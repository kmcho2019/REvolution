module TopModule (
    input clk,
    input in,
    output out
);

    reg d_ff;
    wire xor_out;
    
    // XOR operation combining input and feedback
    assign xor_out = in ^ d_ff;
    
    // Flip-flop implementation using continuous assignment
    assign out = d_ff;
    
    // Positive edge-triggered behavior
    always @(posedge clk) begin
        d_ff <= xor_out;
    end

endmodule