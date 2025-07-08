module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    // State encoding
    typedef enum logic [2:0] {
        S0  = 3'd0, // 0 consecutive ones
        S1  = 3'd1,
        S2  = 3'd2,
        S3  = 3'd3,
        S4  = 3'd4,
        S5  = 3'd5,
        S6  = 3'd6, // 6 ones detected -> flag
        S7  = 3'd7  // error state (7 or more ones)
    } state_t;

    state_t state, next_state;

    // Sequential logic: state transition and outputs
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            disc  <= 1'b0;
            flag  <= 1'b0;
            err   <= 1'b0;
        end else begin
            state <= next_state;

            // Output logic is Moore type based on next_state
            // Outputs asserted one cycle after detection

            // Default outputs
            disc <= 1'b0;
            flag <= 1'b0;
            err  <= 1'b0;

            case (next_state)
                S0: begin
                    // disc output when we transition from S5 -> S0 on input 0
                    // We assert disc here if previous state was S5 and input was 0
                    if (state == S5 && in == 1'b0)
                        disc <= 1'b1;
                end
                S6: begin
                    // flag asserted when in S6 (6 ones)
                    flag <= 1'b1;
                end
                S7: begin
                    // error asserted when in error state (7 or more ones)
                    err <= 1'b1;
                end
            endcase
        end
    end

    // Combinational next state logic
    always @(*) begin
        case (state)
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
                    next_state = S6; // 6 ones detected (flag)
                else
                    next_state = S0; // discard zero
            end
            S6: begin
                if (in)
                    next_state = S7; // error state: 7 or more ones
                else
                    next_state = S0;
            end
            S7: begin
                if (in)
                    next_state = S7; // stay in error on consecutive ones
                else
                    next_state = S0;
            end
            default: next_state = S0;
        endcase
    end

endmodule