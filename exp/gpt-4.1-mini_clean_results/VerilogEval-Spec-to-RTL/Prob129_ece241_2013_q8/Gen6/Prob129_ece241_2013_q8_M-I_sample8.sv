module TopModule (
    input  clk,
    input  aresetn,
    input  x,
    output reg z
);

    // One-hot state encoding: only one bit high at a time
    typedef enum logic [2:0] {
        S0 = 3'b001, // initial state, no bits matched
        S1 = 3'b010, // matched '1'
        S2 = 3'b100  // matched '10'
    } state_t;

    state_t state, next_state;

    // Asynchronous negative edge reset, synchronous state update
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            state <= S0;
        else
            state <= next_state;
    end

    // Next state and output logic (Mealy FSM)
    always @(*) begin
        z = 1'b0;
        next_state = S0; // default assignment to avoid latches

        case (state)
            S0: begin
                if (x)
                    next_state = S1;
                else
                    next_state = S0;
            end
            S1: begin
                if (!x)
                    next_state = S2;
                else
                    next_state = S1;
            end
            S2: begin
                if (x) begin
                    next_state = S1;
                    z = 1'b1; // sequence "101" detected
                end else
                    next_state = S0;
            end
            default: begin
                next_state = S0;
                z = 1'b0;
            end
        endcase
    end

endmodule