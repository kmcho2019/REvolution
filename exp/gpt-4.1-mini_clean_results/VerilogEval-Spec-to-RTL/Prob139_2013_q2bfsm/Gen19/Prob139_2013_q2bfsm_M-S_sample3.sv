module TopModule(
    input  wire clk,
    input  wire resetn,  // synchronous active low reset
    input  wire x,
    input  wire y,
    output reg  f,
    output reg  g
);

    // State encoding
    typedef enum reg [2:0] {
        RESET        = 3'd0,
        F_PULSE      = 3'd1,
        PATTERN_WAIT = 3'd2,
        G_PULSE      = 3'd3,
        Y_MONITOR_1  = 3'd4,
        Y_MONITOR_2  = 3'd5,
        G1_PERMANENT = 3'd6,
        G0_PERMANENT = 3'd7
    } state_t;

    state_t state, next_state;

    reg [2:0] x_shift; // shift register to detect '101'

    // Sequential logic: state and x_shift update, outputs
    always @(posedge clk) begin
        if (!resetn) begin
            state   <= RESET;
            x_shift <= 3'b000;
            f       <= 1'b0;
            g       <= 1'b0;
        end else begin
            state <= next_state;

            // Shift in x for pattern detection only in PATTERN_WAIT state or later
            if (state == PATTERN_WAIT) begin
                x_shift <= {x_shift[1:0], x};
            end

            // Moore outputs depend on current state
            case (state)
                RESET: begin
                    f <= 1'b0;
                    g <= 1'b0;
                end
                F_PULSE: begin
                    f <= 1'b1;
                    g <= 1'b0;
                end
                PATTERN_WAIT: begin
                    f <= 1'b0;
                    g <= 1'b0;
                end
                G_PULSE: begin
                    f <= 1'b0;
                    g <= 1'b1;
                end
                Y_MONITOR_1: begin
                    f <= 1'b0;
                    g <= 1'b1;
                end
                Y_MONITOR_2: begin
                    f <= 1'b0;
                    g <= 1'b1;
                end
                G1_PERMANENT: begin
                    f <= 1'b0;
                    g <= 1'b1;
                end
                G0_PERMANENT: begin
                    f <= 1'b0;
                    g <= 1'b0;
                end
                default: begin
                    f <= 1'b0;
                    g <= 1'b0;
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case (state)
            RESET: begin
                if (resetn)
                    next_state = F_PULSE;
                else
                    next_state = RESET;
            end
            F_PULSE: begin
                next_state = PATTERN_WAIT;
            end
            PATTERN_WAIT: begin
                // Update x_shift outside this block, check pattern here
                // x_shift always contains last 3 x inputs during this state
                if (x_shift == 3'b101)
                    next_state = G_PULSE;
                else
                    next_state = PATTERN_WAIT;
            end
            G_PULSE: begin
                next_state = Y_MONITOR_1;
            end
            Y_MONITOR_1: begin
                if (y == 1'b1)
                    next_state = G1_PERMANENT;
                else
                    next_state = Y_MONITOR_2;
            end
            Y_MONITOR_2: begin
                if (y == 1'b1)
                    next_state = G1_PERMANENT;
                else
                    next_state = G0_PERMANENT;
            end
            G1_PERMANENT: begin
                next_state = G1_PERMANENT;
            end
            G0_PERMANENT: begin
                next_state = G0_PERMANENT;
            end
            default: begin
                next_state = RESET;
            end
        endcase
    end

endmodule