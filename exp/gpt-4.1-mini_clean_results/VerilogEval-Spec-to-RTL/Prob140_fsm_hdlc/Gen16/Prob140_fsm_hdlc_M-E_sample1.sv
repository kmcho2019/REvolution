module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    typedef enum logic [3:0] {
        S0  = 4'd0, // zero consecutive ones
        S1  = 4'd1,
        S2  = 4'd2,
        S3  = 4'd3,
        S4  = 4'd4,
        S5  = 4'd5, // five consecutive ones
        S6  = 4'd6, // six consecutive ones
        S7P = 4'd7  // seven or more consecutive ones (error)
    } state_t;

    state_t state, next_state;

    // State transition logic
    always @(*) begin
        case (state)
            S0:  next_state = in ? S1  : S0;
            S1:  next_state = in ? S2  : S0;
            S2:  next_state = in ? S3  : S0;
            S3:  next_state = in ? S4  : S0;
            S4:  next_state = in ? S5  : S0;
            S5:  next_state = in ? S6  : S0;
            S6:  next_state = in ? S7P : S0;
            S7P: next_state = in ? S7P : S0;
            default: next_state = S0;
        endcase
    end

    // Outputs registered and determined solely by current state
    // disc for exactly 5 ones followed by a zero (state S5 + input 0 triggers disc next cycle)
    // flag for exactly 6 ones followed by a zero (state S6 + input 0 triggers flag next cycle)
    // err for 7 or more ones (state S7P)
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            disc  <= 1'b0;
            flag  <= 1'b0;
            err   <= 1'b0;
        end else begin
            state <= next_state;

            // Moore outputs: depend only on current state
            disc <= (state == S5) && (in == 1'b0);
            flag <= (state == S6) && (in == 1'b0);
            err  <= (state == S7P);
        end
    end

endmodule