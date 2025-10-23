module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    // State encoding: count of consecutive 1s, saturate at 7
    typedef enum reg [2:0] {
        S0 = 3'd0, // zero consecutive ones
        S1 = 3'd1,
        S2 = 3'd2,
        S3 = 3'd3,
        S4 = 3'd4,
        S5 = 3'd5,
        S6 = 3'd6,
        S7 = 3'd7  // saturate error state for 7 or more ones
    } state_t;

    reg [2:0] state, next_state;

    // Next-state logic combinational
    always @(*) begin
        case (state)
            S0: next_state = in ? S1 : S0;
            S1: next_state = in ? S2 : S0;
            S2: next_state = in ? S3 : S0;
            S3: next_state = in ? S4 : S0;
            S4: next_state = in ? S5 : S0;
            S5: next_state = in ? S6 : S0;
            S6: next_state = in ? S7 : S0;
            S7: next_state = in ? S7 : S0;  // stay saturated error state if input remains 1
            default: next_state = S0;
        endcase
    end

    // State register and Moore outputs synchronous logic
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            disc  <= 1'b0;
            flag  <= 1'b0;
            err   <= 1'b0;
        end else begin
            state <= next_state;

            // Outputs asserted for one cycle, Moore output based on *next_state*
            // disc: zero after 5 ones means transition from S5 to S0 (in=0)
            disc <= (state == S5) && (in == 1'b0);

            // flag: zero after 6 ones means transition from S6 to S0 (in=0)
            flag <= (state == S6) && (in == 1'b0);

            // err: 7 or more ones means in=1 at state S6 or state S7
            // Since next_state will be S7 if at S6 and in=1, and stays at S7 if in=1
            err <= (state == S7) || ((state == S6) && (in == 1'b1));
        end
    end

endmodule