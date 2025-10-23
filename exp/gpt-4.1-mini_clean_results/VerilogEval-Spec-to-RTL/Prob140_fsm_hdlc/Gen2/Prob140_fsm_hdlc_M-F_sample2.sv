module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    // State encoding: count of consecutive ones
    localparam [2:0]
        S0 = 3'd0,
        S1 = 3'd1,
        S2 = 3'd2,
        S3 = 3'd3,
        S4 = 3'd4,
        S5 = 3'd5,
        S6 = 3'd6,
        S7 = 3'd7; // 7 or more ones = error

    reg [2:0] state, next_state;

    // Combinational next state logic
    always @(*) begin
        case (state)
            S0: next_state = in ? S1 : S0;
            S1: next_state = in ? S2 : S0;
            S2: next_state = in ? S3 : S0;
            S3: next_state = in ? S4 : S0;
            S4: next_state = in ? S5 : S0;
            S5: next_state = in ? S6 : S0;
            S6: next_state = in ? S7 : S0;
            S7: next_state = in ? S7 : S0; // hold error state if input=1, else reset
            default: next_state = S0;
        endcase
    end

    // Outputs combinational before registering
    // disc: assert if previous state was S5 and current input is 0 (bit to discard)
    // flag: assert if previous state was S6 and current input is 0 (flag pattern)
    // err: assert if previous state was S7 (error detected last cycle)
    reg disc_w, flag_w, err_w;

    always @(*) begin
        disc_w = 1'b0;
        flag_w = 1'b0;
        err_w = 1'b0;

        // Outputs depend on current state and input to detect sequences
        // But outputs must assert *after* the condition detected (Moore machine)

        // So outputs signal one cycle later, so generate outputs based on current state and input,
        // and register them on the next clock edge.

        // Detect disc: zero after exactly five ones (state S5 + input=0)
        if (state == S5 && in == 1'b0)
            disc_w = 1'b1;

        // Detect flag: zero after exactly six ones (state S6 + input=0)
        if (state == S6 && in == 1'b0)
            flag_w = 1'b1;

        // Detect error: seven or more ones (state S7)
        // Err asserted continuously while in S7 state
        if (state == S7)
            err_w = 1'b1;
    end

    // Sequential logic: register state and outputs
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            disc  <= 1'b0;
            flag  <= 1'b0;
            err   <= 1'b0;
        end else begin
            state <= next_state;
            // Register outputs one cycle after detection (Moore)
            disc  <= disc_w;
            flag  <= flag_w;
            err   <= err_w;
        end
    end

endmodule