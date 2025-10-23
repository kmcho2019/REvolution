module TopModule (
    output reg one
);

    // Single-state FSM implementation
    reg state;  // Only needs 1 bit despite having just 1 state
    
    // Single state encoding
    localparam S_ONE = 1'b0;
    
    // State transition logic (always stays in S_ONE)
    always @(*) begin
        state = S_ONE;
    end
    
    // Output logic (always '1')
    always @(*) begin
        one = 1'b1;
    end
    
    // Initial state
    initial begin
        state = S_ONE;
    end
endmodule