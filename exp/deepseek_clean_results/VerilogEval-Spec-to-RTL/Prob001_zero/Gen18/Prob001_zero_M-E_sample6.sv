module TopModule (
    output reg zero
);
    // Single-state FSM implementation
    parameter IDLE = 1'b0;
    reg state;
    
    initial begin
        state = IDLE;
        zero = 1'b0;
    end
    
    always @(*) begin
        case (state)
            IDLE: zero = 1'b0;
            default: zero = 1'b0;
        endcase
    end
endmodule