module TopModule (
    input clk,
    input reset,
    input data,
    output start_shifting
);

    // One-hot encoded states
    localparam S_IDLE  = 4'b0001;
    localparam S_1     = 4'b0010;
    localparam S_11    = 4'b0100;
    localparam S_DONE  = 4'b1000;
    
    reg [3:0] state, next_state;
    wire fsm_enable = ~start_shifting;
    
    // State register with clock gating
    always @(posedge clk) begin
        if (reset) begin
            state <= S_IDLE;
        end else if (fsm_enable) begin
            state <= next_state;
        end
    end
    
    // Next state logic
    always @(*) begin
        case (state)
            S_IDLE: next_state = data ? S_1 : S_IDLE;
            S_1:    next_state = data ? S_11 : S_IDLE;
            S_11:   next_state = data ? S_11 : (data ? S_DONE : S_IDLE);
            S_DONE: next_state = S_DONE;
            default: next_state = S_IDLE;
        endcase
    end
    
    // Output logic
    assign start_shifting = state[3]; // S_DONE is MSB
    
endmodule