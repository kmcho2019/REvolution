module TopModule(
    input  clk,
    input  resetn,
    input  x,
    input  y,
    output reg f,
    output reg g
);

    // Define states for FSM to track sequence and output behavior
    typedef enum logic [2:0] {
        IDLE       = 3'd0, // Reset asserted or initial
        F_PULSE    = 3'd1, // f=1 one cycle after reset release
        WAIT_1     = 3'd2, // Waiting for first '1' in sequence
        WAIT_10    = 3'd3, // Matched '1', waiting for '0'
        WAIT_101   = 3'd4, // Matched '1','0', waiting for last '1'
        G_MONITOR  = 3'd5, // g=1, monitor y for 2 cycles max
        G_ON       = 3'd6, // g=1 permanently
        G_OFF      = 3'd7  // g=0 permanently
    } state_t;

    state_t state, next_state;

    reg [1:0] y_count, next_y_count; // count up to 2 cycles in G_MONITOR

    // State register and synchronous logic
    always @(posedge clk) begin
        if (!resetn) begin
            state   <= IDLE;
            y_count <= 2'd0;
            f       <= 1'b0;
            g       <= 1'b0;
        end else begin
            state   <= next_state;
            y_count <= next_y_count;

            // Moore outputs depend only on current state
            f <= (next_state == F_PULSE); // f=1 only during F_PULSE state
            case (next_state)
                G_MONITOR, G_ON: g <= 1'b1;
                default:         g <= 1'b0;
            endcase
        end
    end

    // Next state logic combinational
    always @(*) begin
        next_state = state;       // default hold
        next_y_count = y_count;   // default hold

        case(state)
            IDLE: begin
                // Stay here while reset asserted
                if (resetn)
                    next_state = F_PULSE;
                // else remain IDLE
                next_y_count = 2'd0;
            end

            F_PULSE: begin
                // One cycle pulse on f
                next_state = WAIT_1;
                next_y_count = 2'd0;
            end

            // Sequence detection states for pattern 1,0,1 on x
            WAIT_1: begin
                if (x == 1'b1)
                    next_state = WAIT_10;
                else
                    next_state = WAIT_1; // keep waiting for '1'
                next_y_count = 2'd0;
            end

            WAIT_10: begin
                if (x == 1'b0)
                    next_state = WAIT_101;
                else if (x == 1'b1)
                    next_state = WAIT_10; // allow overlapping sequences
                else
                    next_state = WAIT_1;  // unexpected input, restart
                next_y_count = 2'd0;
            end

            WAIT_101: begin
                if (x == 1'b1)
                    next_state = G_MONITOR; // pattern matched, move on
                else if (x == 1'b0)
                    next_state = WAIT_1;    // restart sequence detection
                else
                    next_state = WAIT_1;    // restart if unexpected
                next_y_count = 2'd0;
            end

            G_MONITOR: begin
                // g=1 asserted here, monitor y up to 2 cycles
                if (y == 1'b1) begin
                    next_state = G_ON;      // y detected within 2 cycles
                    next_y_count = 2'd0;
                end else if (y_count == 2'd1) begin
                    // Two cycles elapsed without y=1
                    next_state = G_OFF;
                    next_y_count = 2'd0;
                end else begin
                    // Increment count and remain monitoring
                    next_y_count = y_count + 1'b1;
                    next_state = G_MONITOR;
                end
            end

            G_ON: begin
                // Permanently g=1 until reset
                next_state = G_ON;
                next_y_count = 2'd0;
            end

            G_OFF: begin
                // Permanently g=0 until reset
                next_state = G_OFF;
                next_y_count = 2'd0;
            end

            default: begin
                next_state = IDLE;
                next_y_count = 2'd0;
            end
        endcase
    end

endmodule