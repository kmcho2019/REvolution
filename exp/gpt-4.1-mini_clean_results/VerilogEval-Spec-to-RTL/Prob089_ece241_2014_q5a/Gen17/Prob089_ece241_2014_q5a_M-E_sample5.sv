module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output reg  z
);

    typedef enum logic {S0=1'b0, S1=1'b1} state_t;
    state_t state, next_state;

    // State transition and output logic (Moore machine)
    always @(*) begin
        case(state)
            S0: begin
                next_state = (x == 1'b1) ? S1 : S0;
                z = x;             // Before first '1', output = input
            end
            S1: begin
                next_state = S1;   // Stay in S1 after first '1'
                z = ~x;            // After first '1', output is inverted input
            end
            default: begin
                next_state = S0;
                z = x;
            end
        endcase
    end

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= S0;
        else
            state <= next_state;
    end

endmodule