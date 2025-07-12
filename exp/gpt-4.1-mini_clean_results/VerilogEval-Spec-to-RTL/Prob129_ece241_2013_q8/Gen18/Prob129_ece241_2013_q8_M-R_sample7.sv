module TopModule (
    input  wire clk,
    input  wire aresetn,
    input  wire x,
    output wire z
);

    // Define FSM states with typedef enum for readability
    typedef enum logic [1:0] {
        S_IDLE = 2'd0, // no bits matched
        S_1    = 2'd1, // matched '1'
        S_10   = 2'd2  // matched "10"
    } state_t;

    state_t state, next_state;

    // Next state logic (combinational) using case statement
    always @(*) begin
        case(state)
            S_IDLE:  next_state = x ? S_1  : S_IDLE;
            S_1:     next_state = x ? S_1  : S_10;
            S_10:    next_state = x ? S_1  : S_IDLE;
            default: next_state = S_IDLE;  // safe default
        endcase
    end

    // Output logic (Mealy), purely combinational
    assign z = (state == S_10) && x;

    // State register with asynchronous negative edge reset
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            state <= S_IDLE;
        else
            state <= next_state;
    end

endmodule