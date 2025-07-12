module TopModule (
    output reg zero
);
    // Internal clock (not exposed in interface)
    reg clk = 0;
    
    // Simple state definition
    typedef enum {
        STATE_LOW
    } state_t;
    
    state_t current_state;
    
    // Clock generator (would be external in real design)
    always #5 clk = ~clk;
    
    // State machine that always stays in LOW state
    always @(posedge clk) begin
        case (current_state)
            STATE_LOW: zero <= 1'b0;
        endcase
    end
    
    // Initialization
    initial begin
        current_state = STATE_LOW;
        zero = 1'b0;
    end
endmodule