module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    // FSM states represent count of consecutive ones: 0 to 7 (saturated)
    typedef enum reg [3:0] {
        S0 = 4'd0,
        S1 = 4'd1,
        S2 = 4'd2,
        S3 = 4'd3,
        S4 = 4'd4,
        S5 = 4'd5,
        S6 = 4'd6,
        S7 = 4'd7
    } state_t;

    state_t state, next_state;

    // Next state logic - Moore FSM
    always @(*) begin
        case (state)
            S0: next_state = in ? S1 : S0;
            S1: next_state = in ? S2 : S0;
            S2: next_state = in ? S3 : S0;
            S3: next_state = in ? S4 : S0;
            S4: next_state = in ? S5 : S0;
            S5: next_state = in ? S6 : S0;
            S6: next_state = in ? S7 : S0;
            S7: next_state = in ? S7 : S0; // stay saturated on 7+ ones
            default: next_state = S0;
        endcase
    end

    // Output signals, registered, asserted one cycle after detection
    // We assert disc on transition from S5 and input==0 (detect "0111110")
    // flag on transition from S6 and input==0 (detect "01111110")
    // err when in S6 or S7 and input==1 (7 or more ones)
    reg disc_d, flag_d, err_d;

    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            disc  <= 1'b0;
            flag  <= 1'b0;
            err   <= 1'b0;
        end else begin
            state <= next_state;

            // Generate outputs based on current state and input (Moore outputs)
            disc_d = (state == S5) && (in == 1'b0);
            flag_d = (state == S6) && (in == 1'b0);
            err_d  = (in && ((state == S6) || (state == S7)));

            // Register outputs only when asserted, else clear to reduce toggling
            disc <= disc_d ? 1'b1 : 1'b0;
            flag <= flag_d ? 1'b1 : 1'b0;
            err  <= err_d  ? 1'b1 : 1'b0;
        end
    end

endmodule