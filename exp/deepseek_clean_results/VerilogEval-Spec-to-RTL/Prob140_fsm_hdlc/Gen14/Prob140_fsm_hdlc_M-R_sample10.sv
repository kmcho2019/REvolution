module TopModule (
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

    // State encoding
    localparam S0 = 3'd0;  // 0 consecutive 1s
    localparam S1 = 3'd1;  // 1 consecutive 1
    localparam S2 = 3'd2;  // 2 consecutive 1s
    localparam S3 = 3'd3;  // 3 consecutive 1s
    localparam S4 = 3'd4;  // 4 consecutive 1s
    localparam S5 = 3'd5;  // 5 consecutive 1s
    localparam S6 = 3'd6;  // 6 consecutive 1s
    localparam S7 = 3'd7;  // 7+ consecutive 1s (error)

    reg [2:0] state, next_state;

    // State transitions
    always @(posedge clk) begin
        if (reset) state <= S0;
        else state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (state)
            S0: next_state = in ? S1 : S0;
            S1: next_state = in ? S2 : S0;
            S2: next_state = in ? S3 : S0;
            S3: next_state = in ? S4 : S0;
            S4: next_state = in ? S5 : S0;
            S5: next_state = in ? S6 : S0;
            S6: next_state = in ? S7 : S0;
            S7: next_state = in ? S7 : S0;
            default: next_state = S0;
        endcase
    end

    // Output logic (Moore machine - outputs depend only on state)
    assign disc = (state == S5) & ~in;
    assign flag = (state == S6) & ~in;
    assign err  = (state == S7) & in;

endmodule