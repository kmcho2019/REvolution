module TopModule (
    input clk,
    input in,
    output out
);

    reg state;
    wire xor_result;
    
    // XOR between input and current state
    assign xor_result = in ^ state;
    
    // Output is directly from the flip-flop
    assign out = state;
    
    // State update on clock edge
    always @(posedge clk) begin
        state <= xor_result;
    end

endmodule