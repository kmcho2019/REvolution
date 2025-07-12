module TopModule(
    input  wire clk,
    input  wire reset,
    input  wire in,
    output wire disc,
    output wire flag,
    output wire err
);

    // State encoding: counts 0..6 consecutive ones plus three output states
    localparam 
        S0 = 4'd0, // 0 consecutive ones (also reset state)
        S1 = 4'd1,
        S2 = 4'd2,
        S3 = 4'd3,
        S4 = 4'd4,
        S5 = 4'd5,
        S6 = 4'd6,
        SD = 4'd7, // discard zero after 5 ones detected
        SF = 4'd8, // flag after 6 ones detected
        SE = 4'd9; // error state for 7 or more ones

    reg [3:0] state, next_state;

    // Next-state combinational logic: Moore FSM style with explicit transitions
    always @(*) begin
        case (state)
            // Counting consecutive ones
            S0: next_state = in ? S1 : S0;
            S1: next_state = in ? S2 : S0;
            S2: next_state = in ? S3 : S0;
            S3: next_state = in ? S4 : S0;
            S4: next_state = in ? S5 : S0;
            S5: next_state = in ? S6 : SD; // zero after 5 ones => discard zero
            S6: next_state = in ? SE : SF; // zero after 6 ones => flag; one after 6 => error
            // Output states: disc, flag, err output one cycle, then resume counting from current input
            SD: next_state = in ? S1 : S0;
            SF: next_state = in ? S1 : S0;
            SE: next_state = in ? SE : S0; // remain in error on ones, recover on zero
            default: next_state = S0; // Safety default
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