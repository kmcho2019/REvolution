module TopModule (
    input clk,
    input in,
    output out
);

    reg state;
    
    // Output is the flip-flop state
    assign out = state;
    
    // State update with XOR operation
    always @(posedge clk) begin
        state <= in ^ state;
    end

endmodule