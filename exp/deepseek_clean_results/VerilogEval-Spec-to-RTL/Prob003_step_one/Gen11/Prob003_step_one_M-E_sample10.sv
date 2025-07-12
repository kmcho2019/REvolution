module TopModule (
    output reg one
);
    // Single-state FSM implementation
    localparam STATE = 1'b0;
    
    always @(*) begin
        one = 1'b1;  // Output is always 1 regardless of state
    end
    
    // No actual state transitions needed
endmodule