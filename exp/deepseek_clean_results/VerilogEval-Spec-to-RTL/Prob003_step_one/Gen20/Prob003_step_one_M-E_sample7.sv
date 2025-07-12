module TopModule (
    output one
);
    // State machine implementation of constant 1 output
    reg state;
    
    // Single state machine state (could be expanded later)
    localparam OUTPUT_ONE = 1'b0;
    
    // Combinational output logic
    assign one = (state == OUTPUT_ONE) ? 1'b1 : 1'b1; // Always outputs 1
    
    // State transition logic (stays in same state)
    always @(*) begin
        state = OUTPUT_ONE;
    end
    
    // Initial state (not strictly necessary for this simple case)
    initial begin
        state = OUTPUT_ONE;
    end
endmodule