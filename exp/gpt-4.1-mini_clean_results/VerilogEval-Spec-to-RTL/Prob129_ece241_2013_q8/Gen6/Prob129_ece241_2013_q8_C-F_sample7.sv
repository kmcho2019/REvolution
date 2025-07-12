module TopModule (
    input  clk,
    input  aresetn,
    input  x,
    output reg z
);

    // State encoding using typedef enum for clarity
    typedef enum reg [1:0] {
        S0 = 2'b00, // initial state: no bits matched
        S1 = 2'b01, // matched '1'
        S2 = 2'b10  // matched "10"
    } state_t;

    state_t state, next_state;

    // State register with asynchronous negative-edge reset
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            state <= S0;
        else
            state <= next_state;
    end

    // Next state logic (combinational)
    always @(*) begin
        // Default next_state is current state to avoid inferred latches
        next_state = state;

        case (state)
            S0: begin
                if (x)
                    next_state = S1;
                else
                    next_state = S0;
            end
            S1: begin
                if (~x)
                    next_state = S2;
                else
                    next_state = S1;
            end
            S2: begin
                if (x)
                    next_state = S1;
                else
                    next_state = S0;
            end
            default: next_state = S0;
        endcase
    end

    // Output logic (combinational Mealy output)
    always @(*) begin
        // Default output
        z = 1'b0;

        // Output asserted when sequence "101" detected at S2 and input x=1
        if ((state == S2) && (x == 1'b1))
            z = 1'b1;
    end

endmodule