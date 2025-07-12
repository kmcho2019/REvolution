module TopModule (
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

    // Define FSM states
    typedef enum reg [2:0] {
        S0,  // initial state, no bits matched
        S1,  // matched '1'
        S2,  // matched '11'
        S3,  // matched '110'
        S4   // matched '1101' (sequence found)
    } state_t;

    state_t current_state, next_state;

    // Combinational logic to determine next state
    always @(*) begin
        case (current_state)
            S0: next_state = (data == 1'b1) ? S1 : S0;
            S1: next_state = (data == 1'b1) ? S2 : S0;
            S2: next_state = (data == 1'b0) ? S3 : S2;
            S3: next_state = (data == 1'b1) ? S4 : S0;
            S4: next_state = S4; // stay in final state forever
            default: next_state = S0;
        endcase
    end

    // Sequential logic for state transition and output
    always @(posedge clk) begin
        if (reset) begin
            current_state <= S0;
            start_shifting <= 1'b0;
        end else begin
            current_state <= next_state;
            if (current_state == S4)
                start_shifting <= 1'b1;
            else if (start_shifting == 1'b1)
                start_shifting <= 1'b1; // hold once set
            else
                start_shifting <= 1'b0;
        end
    end

endmodule