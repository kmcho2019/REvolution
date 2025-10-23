module TopModule(
    input  wire clk,
    input  wire reset,
    input  wire in,
    output wire disc,
    output wire flag,
    output wire err
);

    // State encoding (4-bit):
    // S0..S6: number of consecutive ones counted (0 to 6)
    // SD: disc output state (after 5 consecutive ones + 0)
    // SF: flag output state (after 6 consecutive ones + 0)
    // SE: error state (7 or more consecutive ones)
    localparam 
        S0 = 4'd0,
        S1 = 4'd1,
        S2 = 4'd2,
        S3 = 4'd3,
        S4 = 4'd4,
        S5 = 4'd5,
        S6 = 4'd6,
        SD = 4'd7,
        SF = 4'd8,
        SE = 4'd9;

    reg [3:0] state, next_state;

    // Next state logic
    always @(*) begin
        case(state)
            // Count states 0 to 6 consecutive ones
            S0: next_state = in ? S1 : S0;
            S1: next_state = in ? S2 : S0;
            S2: next_state = in ? S3 : S0;
            S3: next_state = in ? S4 : S0;
            S4: next_state = in ? S5 : S0;
            S5: next_state = in ? S6 : SD;  // if in=0 after 5 ones => discard zero
            S6: next_state = in ? SE : SF;  // if in=0 after 6 ones => flag, else error (7+ ones)
            // Output states: after disc, flag, or err pulse, go to S0 or S1 according to input
            SD: next_state = in ? S1 : S0;
            SF: next_state = in ? S1 : S0;
            SE: next_state = in ? SE : S0;
            default: next_state = S0;
        endcase
    end

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

    // Moore outputs depend only on current state
    assign disc = (state == SD);
    assign flag = (state == SF);
    assign err  = (state == SE);

endmodule