module TopModule (
    input clk,
    input in,
    output out
);

    reg state;
    wire xor1, xor2;
    
    // First XOR: input ^ current state
    assign xor1 = in ^ state;
    
    // Second XOR: result ^ delayed version (creates more complex pattern)
    assign xor2 = xor1 ^ state;
    
    // Final output is the second XOR result
    assign out = xor2;
    
    // State update on clock edge
    always @(posedge clk) begin
        state <= xor1;
    end

endmodule