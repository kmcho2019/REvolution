module TopModule (
    input  clk,
    input  reset,
    input  in,
    output reg disc,
    output reg flag,
    output reg err
);

    // States: count of consecutive 1s so far
    typedef enum reg [2:0] {
        S0 = 3'd0, // 0 consecutive 1s
        S1 = 3'd1, // 1 consecutive 1s
        S2 = 3'd2, // 2 consecutive 1s
        S3 = 3'd3, // 3 consecutive 1s
        S4 = 3'd4, // 4 consecutive 1s
        S5 = 3'd5, // 5 consecutive 1s
        S6 = 3'd6  // 6 consecutive 1s
    } state_t;

    state_t state, next_state;

    // Output signals depend on current state and input in Moore style,
    // but outputs are asserted for one cycle after detection, so outputs registered.
    // We generate outputs combinationally for next state and register them in sequential block.

    reg disc_next, flag_next, err_next;

    // Next state logic and output logic
    always @(*) begin
        // Default assignments
        next_state = S0;
        disc_next = 1'b0;
        flag_next = 1'b0;
        err_next = 1'b0;

        case(state)
            S0: begin
                if (in)
                    next_state = S1;
                else
                    next_state = S0;
            end
            S1: begin
                if (in)
                    next_state = S2;
                else
                    next_state = S0;
            end
            S2: begin
                if (in)
                    next_state = S3;
                else
                    next_state = S0;
            end
            S3: begin
                if (in)
                    next_state = S4;
                else
                    next_state = S0;
            end
            S4: begin
                if (in)
                    next_state = S5;
                else
                    next_state = S0;
            end
            S5: begin
                if (in)
                    next_state = S6;
                else begin
                    // Input 0 after 5 consecutive 1s: disc = 1
                    next_state = S0;
                    disc_next = 1'b1;
                end
            end
            S6: begin
                if (in) begin
                    // 7 or more consecutive 1s: error
                    next_state = S6;
                    err_next = 1'b1;
                end
                else begin
                    // input 0 after 6 consecutive 1s: flag detected
                    next_state = S0;
                    flag_next = 1'b1;
                end
            end
            default: begin
                next_state = S0;
            end
        endcase
    end

    // State and outputs sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            disc <= 1'b0;
            flag <= 1'b0;
            err <= 1'b0;
        end else begin
            state <= next_state;
            disc <= disc_next;
            flag <= flag_next;
            err <= err_next;
        end
    end

endmodule