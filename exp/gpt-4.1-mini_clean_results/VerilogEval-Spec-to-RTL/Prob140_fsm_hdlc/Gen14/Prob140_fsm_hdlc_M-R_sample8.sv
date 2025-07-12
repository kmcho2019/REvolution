module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output wire disc,
    output wire flag,
    output wire err
);

    // Define FSM states for counts of consecutive ones (0 to 7+)
    typedef enum logic [3:0] {
        S0  = 4'd0,  // No consecutive ones
        S1  = 4'd1,
        S2  = 4'd2,
        S3  = 4'd3,
        S4  = 4'd4,
        S5  = 4'd5,  // Five consecutive ones
        S6  = 4'd6,  // Six consecutive ones
        S7p = 4'd7   // Seven or more consecutive ones (error state)
    } state_t;

    state_t state, next_state;

    // Next state logic (combinational)
    always @(*) begin
        case (state)
            S0:  next_state = in ? S1  : S0;
            S1:  next_state = in ? S2  : S0;
            S2:  next_state = in ? S3  : S0;
            S3:  next_state = in ? S4  : S0;
            S4:  next_state = in ? S5  : S0;
            S5:  next_state = in ? S6  : S0; // zero after 5 ones means discard next zero
            S6:  next_state = in ? S7p : S0; // zero after 6 ones means flag
            S7p: next_state = in ? S7p : S0; // stays in error on consecutive ones
            default: next_state = S0;
        endcase
    end

    // Sequential state update
    always @(posedge clk) begin
        if (reset) begin
            state <= S0; // on reset, assume previous input was zero
        end else begin
            state <= next_state;
        end
    end

    // Moore outputs: asserted for one full cycle after detecting condition

    // disc: set on cycle after seeing 5 consecutive ones followed by zero (S5 + zero input)
    assign disc = (state == S5) && (in == 1'b0);

    // flag: set on cycle after seeing 6 consecutive ones followed by zero (S6 + zero input)
    assign flag = (state == S6) && (in == 1'b0);

    // err: set if in or beyond S7p state with input=1 (7+ consecutive ones)
    assign err = ( (state == S7p) || (state == S6 && in == 1'b1) );

endmodule