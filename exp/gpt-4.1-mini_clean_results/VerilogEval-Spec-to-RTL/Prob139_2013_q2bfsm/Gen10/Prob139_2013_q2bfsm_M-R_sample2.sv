module TopModule(
    input  wire clk,
    input  wire resetn,  // synchronous active low reset
    input  wire x,
    input  wire y,
    output reg  f,
    output reg  g
);

    // State encoding using localparams
    localparam [2:0]
        A          = 3'd0,  // Reset state
        F_PULSE    = 3'd1,  // f=1 for 1 cycle
        PATTERN    = 3'd2,  // Shift and detect pattern 101 on x
        Y_MONITOR  = 3'd3,  // g=1, monitor y up to 2 cycles
        G_ON       = 3'd4,  // g=1 permanently until reset
        G_OFF      = 3'd5;  // g=0 permanently until reset

    reg [2:0] state, next_state;

    // Shift register for x input pattern detection
    reg [2:0] x_shift, next_x_shift;

    // Counter for y monitoring in Y_MONITOR (counts 0 and 1)
    reg [1:0] y_cnt, next_y_cnt;

    // Sequential logic: state, x_shift, y_cnt, f, g update
    always @(posedge clk) begin
        if (!resetn) begin
            // Synchronous active low reset: go to A state, clear regs, outputs low
            state   <= A;
            x_shift <= 3'b000;
            y_cnt   <= 2'd0;
            f       <= 1'b0;
            g       <= 1'b0;
        end else begin
            state   <= next_state;
            x_shift <= next_x_shift;
            y_cnt   <= next_y_cnt;
            f       <= (next_state == F_PULSE);
            g       <= (next_state == Y_MONITOR) || (next_state == G_ON);
        end
    end

    // Combinational next state and internal signal logic
    always @(*) begin
        // Default assignments to hold values
        next_state   = state;
        next_x_shift = x_shift;
        next_y_cnt   = y_cnt;

        case(state)
            A: begin
                // Stay here while reset asserted
                // When resetn deasserted, move to F_PULSE
                // Since reset is synchronous, this happens on posedge clk
                next_state   = F_PULSE;
                next_x_shift = 3'b000;
                next_y_cnt   = 2'd0;
            end

            F_PULSE: begin
                // Output f=1 one cycle here (done by sequential block)
                // Next move to pattern detection state
                next_state   = PATTERN;
                next_x_shift = 3'b000;
                next_y_cnt   = 2'd0;
            end

            PATTERN: begin
                // Shift x into shift register each cycle
                next_x_shift = {x_shift[1:0], x};

                // Check pattern 3'b101 (oldest bit is x_shift[2])
                if (next_x_shift == 3'b101) begin
                    // Pattern detected, move to Y_MONITOR
                    next_state = Y_MONITOR;
                    next_y_cnt = 2'd0;
                    // x_shift can be cleared or held, not used further
                    next_x_shift = 3'b000;
                end else begin
                    // Keep searching pattern
                    next_state = PATTERN;
                    next_y_cnt = 2'd0;
                end
            end

            Y_MONITOR: begin
                // g=1 during this state (set in sequential block)
                // Monitor y for max 2 cycles: y_cnt counts 0 and 1
                if (y == 1'b1) begin
                    // y detected within allowed cycles, go to G_ON
                    next_state = G_ON;
                    next_y_cnt = 2'd0;
                end else if (y_cnt == 2'd1) begin
                    // 2 cycles elapsed without y=1, go to G_OFF
                    next_state = G_OFF;
                    next_y_cnt = 2'd0;
                end else begin
                    // Increment counter, stay in Y_MONITOR
                    next_state = Y_MONITOR;
                    next_y_cnt = y_cnt + 1'b1;
                end

                // x_shift unused here
                next_x_shift = 3'b000;
            end

            G_ON: begin
                // g=1 permanently
                next_state   = G_ON;
                next_x_shift = 3'b000;
                next_y_cnt   = 2'd0;
            end

            G_OFF: begin
                // g=0 permanently
                next_state   = G_OFF;
                next_x_shift = 3'b000;
                next_y_cnt   = 2'd0;
            end

            default: begin
                // Unknown state: reset FSM to A
                next_state   = A;
                next_x_shift = 3'b000;
                next_y_cnt   = 2'd0;
            end
        endcase
    end

endmodule