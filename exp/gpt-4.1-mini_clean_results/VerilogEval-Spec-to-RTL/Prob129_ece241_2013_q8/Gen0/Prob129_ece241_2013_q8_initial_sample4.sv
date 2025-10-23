module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output reg z
);

    // State encoding
    typedef enum reg [1:0] {
        S0 = 2'b00, // no match yet
        S1 = 2'b01, // matched '1'
        S2 = 2'b10  // matched "10"
    } state_t;

    state_t state, next_state;

    // Asynchronous negative edge reset
    always @(negedge aresetn or posedge clk) begin
        if (!aresetn)
            state <= S0;
        else
            state <= next_state;
    end

    // Next state and output logic (Mealy FSM)
    always @(*) begin
        // Default values
        next_state = state;
        z = 1'b0;

        case(state)
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