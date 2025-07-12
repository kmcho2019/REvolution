module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    // Define states representing count of consecutive ones 0..7+
    typedef enum reg [3:0] {
        S0 = 4'd0,  // 0 consecutive ones
        S1 = 4'd1,  // 1 consecutive one
        S2 = 4'd2,  // 2 consecutive ones
        S3 = 4'd3,  // 3 consecutive ones
        S4 = 4'd4,  // 4 consecutive ones
        S5 = 4'd5,  // 5 consecutive ones
        S6 = 4'd6,  // 6 consecutive ones
        S7 = 4'd7   // 7 or more consecutive ones (saturated error state)
    } state_t;

    state_t state, next_state;

    // Next-state logic: combinational
    always @(*) begin
        case (state)
            S0: next_state = in ? S1 : S0;
            S1: next_state = in ? S2 : S0;
            S2: next_state = in ? S3 : S0;
            S3: next_state = in ? S4 : S0;
            S4: next_state = in ? S5 : S0;
            S5: next_state = in ? S6 : S0;
            S6: next_state = in ? S7 : S0;
            S7: next_state = in ? S7 : S0; // stay in error if continuing ones
            default: next_state = S0;
        endcase
    end

    // Sequential state update
    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

    // Moore output logic: depends only on current state
    always @(posedge clk) begin
        // Default outputs
        disc <= 1'b0;
        flag <= 1'b0;
        err  <= 1'b0;

        case (state)
            // disc asserted for one cycle after seeing 5 consecutive ones then zero (i.e., on next clock)
            S5: if (~in) disc <= 1'b1;
            // flag asserted for one cycle after seeing 6 consecutive ones then zero
            S6: if (~in) flag <= 1'b1;
            // err asserted whenever 7 or more consecutive ones (S7), or last input extending 6->7 ones
            S7: err <= 1'b1;
            default: ;
        endcase
    end

endmodule