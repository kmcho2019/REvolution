module TopModule (
    input  clk,
    input  aresetn,
    input  x,
    output reg z
);

    typedef enum reg [1:0] {
        S0 = 2'b00, // no match
        S1 = 2'b01, // matched '1'
        S2 = 2'b10  // matched '10'
    } state_t;

    state_t state, next_state;

    // Asynchronous negative edge reset, synchronous state update
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            state <= S0;
        else
            state <= next_state;
    end

    // Next state logic and output logic (Mealy FSM)
    always @(*) begin
        z = 1'b0;
        case(state)
            S0: begin
                if (x)
                    next_state = S1;
                else
                    next_state = S0;
            end
            S1: begin
                if (x)
                    next_state = S1;  // '11' so stay in S1
                else
                    next_state = S2;  // '10'
            end
            S2: begin
                if (x) begin
                    next_state = S1; // detected "101"
                    z = 1'b1;
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