module TopModule (
    output reg one
);
    // Define state machine states (only one needed)
    localparam STATE_OUTPUT_ONE = 1'b0;
    
    reg state;
    
    initial begin
        state = STATE_OUTPUT_ONE;
        one = 1'b1;
    end
    
    // State machine that always outputs 1
    always @(*) begin
        case (state)
            STATE_OUTPUT_ONE: one = 1'b1;
            default: one = 1'b1;  // Redundant but complete
        endcase
    end
endmodule