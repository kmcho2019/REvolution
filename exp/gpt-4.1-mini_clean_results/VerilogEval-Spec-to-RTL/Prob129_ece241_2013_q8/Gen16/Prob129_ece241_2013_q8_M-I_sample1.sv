module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output reg z
);

    // One-hot state encoding: only one bit high per state
    typedef enum logic [2:0] {
        S_IDLE = 3'b001, // waiting for '1'
        S_1    = 3'b010, // matched '1'
        S_10   = 3'b100  // matched "10"
    } state_t;

    state_t state, next_state;

    // Next-state and output (Mealy) logic combined
    always @(*) begin
        // Defaults
        next_state = state;
        z = 1'b0;

        case (state)
            S_IDLE: begin
                if (x) next_state = S_1;
                else   next_state = S_IDLE;
            end

            S_1: begin
                if (x) next_state = S_1;
                else   next_state = S_10;
            end

            S_10: begin
                // Output asserted here when input 'x' is '1' detecting "101"
                z = x;
                if (x) next_state = S_1;
                else   next_state = S_IDLE;
            end

            default: begin
                next_state = S_IDLE;
                z = 1'b0;
            end
        endcase
    end

    // State register with asynchronous negative-edge reset
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            state <= S_IDLE;
        else
            state <= next_state;
    end

endmodule