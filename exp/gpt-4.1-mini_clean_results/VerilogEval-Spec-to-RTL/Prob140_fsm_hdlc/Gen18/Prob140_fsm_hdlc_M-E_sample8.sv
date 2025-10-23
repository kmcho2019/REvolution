module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    typedef enum reg [3:0] {
        S0 = 4'd0,  // zero consecutive ones
        S1 = 4'd1,
        S2 = 4'd2,
        S3 = 4'd3,
        S4 = 4'd4,
        S5 = 4'd5,
        S6 = 4'd6,
        S7 = 4'd7,  // seven or more consecutive ones (error state)
        SERR = 4'd8 // error state stable (once error asserted)
    } state_t;

    reg [3:0] state, next_state;

    // State transition logic (combinational)
    always @(*) begin
        case (state)
            S0: next_state = in ? S1 : S0;
            S1: next_state = in ? S2 : S0;
            S2: next_state = in ? S3 : S0;
            S3: next_state = in ? S4 : S0;
            S4: next_state = in ? S5 : S0;
            S5: next_state = in ? S6 : S0;
            S6: next_state = in ? S7 : S0;
            S7: next_state = in ? SERR : S0;
            SERR: next_state = in ? SERR : S0;
            default: next_state = S0;
        endcase
    end

    // Output logic based on current state (Moore)
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            disc  <= 1'b0;
            flag  <= 1'b0;
            err   <= 1'b0;
        end else begin
            state <= next_state;

            // By Moore FSM definition, outputs depend only on current state before transition
            disc <= (state == S5) && ~in;   // seen 5 ones followed by a zero input (discard inserted 0)
            flag <= (state == S6) && ~in;   // seen 6 ones followed by zero input (flag)
            err  <= (state == S7) && in;    // 7 or more consecutive ones
        end
    end

endmodule