module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    // State encoding (4-bit for clear output states)
    localparam [3:0]
        S0 = 4'd0,  // zero consecutive ones
        S1 = 4'd1,  // 1 consecutive one
        S2 = 4'd2,
        S3 = 4'd3,
        S4 = 4'd4,
        S5 = 4'd5,
        S6 = 4'd6,
        SD = 4'd7,  // disc output state (detect "0111110")
        SF = 4'd8,  // flag output state (detect "01111110")
        SE = 4'd9;  // error state (7 or more ones)

    reg [3:0] state, next_state;

    // Next state logic: combinational, driven by current state and input
    always @(*) begin
        case (state)
            S0: next_state = in ? S1 : S0;
            S1: next_state = in ? S2 : S0;
            S2: next_state = in ? S3 : S0;
            S3: next_state = in ? S4 : S0;
            S4: next_state = in ? S5 : S0;
            S5: next_state = in ? S6 : SD;  // zero after 5 ones -> disc output state
            S6: next_state = in ? SE : SF;  // zero after 6 ones -> flag output state, one after 6 ones -> error
            SD: next_state = in ? S1 : S0;  // after disc output, resume counting from input
            SF: next_state = in ? S1 : S0;  // after flag output, resume counting
            SE: next_state = in ? SE : S0;  // error state holds on ones, reset on zero
            default: next_state = S0;
        endcase
    end

    // Sequential logic: state update and outputs synchronous to clk posedge, reset active high
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            disc <= 1'b0;
            flag <= 1'b0;
            err  <= 1'b0;
        end else begin
            state <= next_state;

            // Moore outputs depend only on current state
            disc <= (next_state == SD);
            flag <= (next_state == SF);
            err  <= (next_state == SE);
        end
    end

endmodule