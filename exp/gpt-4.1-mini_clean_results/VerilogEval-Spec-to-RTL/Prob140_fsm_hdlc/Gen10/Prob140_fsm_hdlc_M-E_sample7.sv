module TopModule(
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    // State encoding
    typedef enum reg [3:0] {
        ZERO = 4'd0,  // no consecutive ones
        ONE  = 4'd1,  // 1 consecutive one
        TWO  = 4'd2,
        THREE= 4'd3,
        FOUR = 4'd4,
        FIVE = 4'd5,
        SIX  = 4'd6,
        DISC  = 4'd7, // output disc one cycle
        FLAG  = 4'd8, // output flag one cycle
        ERR   = 4'd9  // output error one cycle and latch until reset
    } state_t;

    state_t state, next_state;

    // Combinational next state logic
    always @(*) begin
        disc = 1'b0;
        flag = 1'b0;
        err  = 1'b0;
        next_state = state;

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
                    next_state = DISC;  // 5 consecutive ones followed by zero -> disc
            end
            SIX: begin
                if (in)
                    next_state = ERR;   // 7+ consecutive ones -> err
                else
                    next_state = FLAG;  // 6 consecutive ones followed by zero -> flag
            end
            DISC: begin
                // Output disc for one cycle, then back to ZERO
                next_state = ZERO;
                disc = 1'b1;
            end
            FLAG: begin
                // Output flag for one cycle, then back to ZERO
                next_state = ZERO;
                flag = 1'b1;
            end
            ERR: begin
                // Output err until reset
                err = 1'b1;
                next_state = ERR;
            end
            default: begin
                next_state = ZERO;
            end
        endcase
    end

    // Sequential state and outputs update
    always @(posedge clk) begin
        if (reset) begin
            state <= ZERO;
            disc  <= 1'b0;
            flag  <= 1'b0;
            err   <= 1'b0;
        end else begin
            state <= next_state;
            // Output signals only asserted during DISC, FLAG or ERR states
            // Clear outputs otherwise (except ERR stays asserted)
            if (next_state == DISC) begin
                disc <= 1'b1;
                flag <= 1'b0;
                err  <= 1'b0;
            end else if (next_state == FLAG) begin
                disc <= 1'b0;
                flag <= 1'b1;
                err  <= 1'b0;
            end else if (next_state == ERR) begin
                disc <= 1'b0;
                flag <= 1'b0;
                err  <= 1'b1;
            end else begin
                disc <= 1'b0;
                flag <= 1'b0;
                // err remains asserted only if state ERR, but here state is not ERR => clear
                err  <= 1'b0;
            end
        end
    end

endmodule