module TopModule(
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    // Define states encoding consecutive ones count
    typedef enum reg [3:0] {
        ZERO  = 4'd0, // no consecutive ones
        ONE   = 4'd1,
        TWO   = 4'd2,
        THREE = 4'd3,
        FOUR  = 4'd4,
        FIVE  = 4'd5,
        DISCARD = 4'd6, // 5 ones + zero detected, disc output next cycle
        SIX   = 4'd7,
        FLAG  = 4'd8, // 6 ones + zero detected, flag output next cycle
        SEVEN = 4'd9, // error state - 7 consecutive ones or more
        ERROR = 4'd10
    } state_t;

    state_t state, next_state;

    // Moore outputs depend only on state
    always @(*) begin
        disc = 1'b0;
        flag = 1'b0;
        err  = 1'b0;

        case(state)
            DISCARD: disc = 1'b1;
            FLAG:    flag = 1'b1;
            SEVEN,
            ERROR:   err = 1'b1;
            default: begin end
        endcase
    end

    // Next state logic
    always @(*) begin
        next_state = ZERO; // default

        case(state)
            ZERO: begin
                if (in)
                    next_state = ONE;
                else
                    next_state = ZERO;
            end

            ONE: begin
                if (in)
                    next_state = TWO;
                else
                    next_state = ZERO;
            end

            TWO: begin
                if (in)
                    next_state = THREE;
                else
                    next_state = ZERO;
            end

            THREE: begin
                if (in)
                    next_state = FOUR;
                else
                    next_state = ZERO;
            end

            FOUR: begin
                if (in)
                    next_state = FIVE;
                else
                    next_state = ZERO;
            end

            FIVE: begin
                if (in)
                    next_state = SIX;
                else
                    next_state = DISCARD; // 5 ones + zero => discard next cycle
            end

            DISCARD: begin
                // After discarding inserted zero, next input processed anew
                if (in)
                    next_state = ONE;
                else
                    next_state = ZERO;
            end

            SIX: begin
                if (in)
                    next_state = SEVEN; // error condition: 7 consecutive ones
                else
                    next_state = FLAG; // 6 ones + zero => flag next cycle
            end

            FLAG: begin
                // After flag output, reset count on next input
                if (in)
                    next_state = ONE;
                else
                    next_state = ZERO;
            end

            SEVEN: begin
                // Error state: seven or more consecutive ones
                if (in)
                    next_state = ERROR; // stay in error if more ones
                else
                    next_state = ZERO;  // reset on zero input
            end

            ERROR: begin
                // Stay in error until reset or zero input resets FSM
                if (in)
                    next_state = ERROR;
                else
                    next_state = ZERO;
            end

            default: next_state = ZERO;
        endcase
    end

    // Sequential state update on clock edge with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= ZERO;
        else
            state <= next_state;
    end

endmodule