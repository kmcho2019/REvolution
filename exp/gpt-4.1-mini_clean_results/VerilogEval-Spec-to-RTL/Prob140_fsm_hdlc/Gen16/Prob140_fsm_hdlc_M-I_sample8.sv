module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    // State encoding: number of consecutive ones seen (0 to 7+)
    // 3 bits sufficient to count 0-7+
    typedef enum reg [2:0] {
        S0 = 3'd0, // last input was 0 or reset
        S1 = 3'd1,
        S2 = 3'd2,
        S3 = 3'd3,
        S4 = 3'd4,
        S5 = 3'd5,
        S6 = 3'd6,
        S7 = 3'd7  // 7 or more ones (error state)
    } state_t;

    state_t state, next_state;

    // Next state logic
    always @(*) begin
        case(state)
            S0: next_state = in ? S1 : S0;
            S1: next_state = in ? S2 : S0;
            S2: next_state = in ? S3 : S0;
            S3: next_state = in ? S4 : S0;
            S4: next_state = in ? S5 : S0;
            S5: next_state = in ? S6 : S0;
            S6: next_state = in ? S7 : S0;  // error if another 1 comes
            S7: next_state = in ? S7 : S0;  // stay error if input 1, else reset
            default: next_state = S0;
        endcase
    end

    // Output logic: outputs asserted one cycle after the event, Moore FSM style
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            disc  <= 1'b0;
            flag  <= 1'b0;
            err   <= 1'b0;
        end else begin
            state <= next_state;

            // disc asserted when previous state was S5 and input=0 (means pattern 0111110 detected)
            disc <= (state == S5) && (in == 1'b0);
            // flag asserted when previous state was S6 and input=0 (means pattern 01111110 detected)
            flag <= (state == S6) && (in == 1'b0);
            // err asserted when previous state was S7 and input=1 (means 7+ consecutive ones)
            err  <= (state == S7) && (in == 1'b1);
        end
    end

endmodule