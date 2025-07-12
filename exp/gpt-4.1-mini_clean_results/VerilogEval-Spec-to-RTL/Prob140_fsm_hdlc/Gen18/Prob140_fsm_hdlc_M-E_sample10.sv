module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    typedef enum logic [2:0] {
        S0  = 3'd0, // 0 consecutive ones
        S1  = 3'd1, // 1 one
        S2  = 3'd2, // 2 ones
        S3  = 3'd3, // 3 ones
        S4  = 3'd4, // 4 ones
        S5  = 3'd5, // 5 ones
        S6  = 3'd6, // 6 ones (flag candidate)
        S7  = 3'd7  // 7 or more ones (error)
    } state_t;

    state_t state, next_state;

    // Sequential state update with synchronous active-high reset
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            disc  <= 1'b0;
            flag  <= 1'b0;
            err   <= 1'b0;
        end else begin
            state <= next_state;

            // Outputs asserted one cycle after detection (Moore outputs)
            // disc: after seeing 5 ones then zero
            disc <= (state == S5) && (in == 1'b0);

            // flag: after seeing 6 ones then zero
            flag <= (state == S6) && (in == 1'b0);

            // err: when in error state (7 or more ones)
            err  <= (state == S7);
        end
    end

    // Next state combinational logic
    always @(*) begin
        case (state)
            S0: next_state = (in) ? S1 : S0;
            S1: next_state = (in) ? S2 : S0;
            S2: next_state = (in) ? S3 : S0;
            S3: next_state = (in) ? S4 : S0;
            S4: next_state = (in) ? S5 : S0;
            S5: next_state = (in) ? S6 : S0;
            S6: next_state = (in) ? S7 : S0;
            S7: next_state = (in) ? S7 : S0;
            default: next_state = S0;
        endcase
    end

endmodule