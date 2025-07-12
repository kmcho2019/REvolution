module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    typedef enum logic [3:0] {
        IDLE  = 4'd0,
        ONE   = 4'd1,
        TWO   = 4'd2,
        THREE = 4'd3,
        FOUR  = 4'd4,
        FIVE  = 4'd5,
        SIX   = 4'd6,
        ERROR = 4'd7
    } state_t;

    state_t state, next_state;

    // Next state logic and output generation combinational
    always @(*) begin
        // Default next state is current state
        next_state = state;
        disc = 1'b0;
        flag = 1'b0;
        err  = 1'b0;

        case (state)
            IDLE: begin
                if (in)
                    next_state = ONE;
                else
                    next_state = IDLE;
            end
            ONE: begin
                if (in)
                    next_state = TWO;
                else
                    next_state = IDLE;
            end
            TWO: begin
                if (in)
                    next_state = THREE;
                else
                    next_state = IDLE;
            end
            THREE: begin
                if (in)
                    next_state = FOUR;
                else
                    next_state = IDLE;
            end
            FOUR: begin
                if (in)
                    next_state = FIVE;
                else
                    next_state = IDLE;
            end
            FIVE: begin
                if (in) 
                    next_state = SIX;
                else begin
                    // zero after 5 ones: discard bit this cycle
                    disc = 1'b1;
                    next_state = IDLE;
                end
            end
            SIX: begin
                if (in) begin
                    // 7 ones or more => error state and err asserted
                    next_state = ERROR;
                    err = 1'b1;
                end else begin
                    // zero after 6 ones: flag this cycle
                    flag = 1'b1;
                    next_state = IDLE;
                end
            end
            ERROR: begin
                // Stay in error until reset
                next_state = ERROR;
                err = 1'b1;
            end
            default: begin
                next_state = IDLE;
            end
        endcase
    end

    // State register and outputs update
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            disc  <= 1'b0;
            flag  <= 1'b0;
            err   <= 1'b0;
        end else begin
            state <= next_state;
            // Outputs disc, flag, err are from combinational above
            // but assigned here synchronously for one-cycle pulse
            disc <= disc;
            flag <= flag;
            err  <= err;
        end
    end

endmodule