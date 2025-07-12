module TopModule (
    input clk,
    input in,
    output out
);

    reg state = 1'b0;
    wire xor_out;
    
    // XOR between input and current state
    assign xor_out = in ^ state;
    
    // Output is the flip-flop state
    assign out = state;
    
    // State update on clock edge
    always @(posedge clk) begin
        state <= xor_out;
    end

endmodule