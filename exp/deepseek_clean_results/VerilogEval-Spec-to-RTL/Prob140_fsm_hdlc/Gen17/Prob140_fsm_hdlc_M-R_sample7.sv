module TopModule (
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

    // State encoding
    parameter IDLE = 3'd0;
    parameter ONE = 3'd1;
    parameter TWO = 3'd2;
    parameter THREE = 3'd3;
    parameter FOUR = 3'd4;
    parameter FIVE = 3'd5;
    parameter SIX = 3'd6;
    parameter ERROR = 3'd7;

    reg [2:0] state, next_state;

    // State transition logic
    always @(*) begin
        case (state)
            IDLE:   next_state = in ? ONE : IDLE;
            ONE:    next_state = in ? TWO : IDLE;
            TWO:    next_state = in ? THREE : IDLE;
            THREE:  next_state = in ? FOUR : IDLE;
            FOUR:   next_state = in ? FIVE : IDLE;
            FIVE:   next_state = in ? SIX : IDLE;
            SIX:   next_state = in ? ERROR : IDLE;
            ERROR:  next_state = in ? ERROR : IDLE;
            default: next_state = IDLE;
        endcase
    end

    // State register
    always @(posedge clk) begin
        if (reset) state <= IDLE;
        else state <= next_state;
    end

    // Output logic (combinational)
    assign disc = (state == FIVE) && !in;
    assign flag = (state == SIX) && !in;
    assign err = (state == ERROR);

endmodule