module TopModule(
    input  wire clk,
    input  wire resetn,  // synchronous active low reset
    input  wire x,
    input  wire y,
    output reg  f,
    output reg  g
);

    // States encoding
    localparam [2:0]
        IDLE         = 3'd0,
        F_PULSE      = 3'd1,
        PATTERN_WAIT = 3'd2,
        Y_MONITOR    = 3'd3,
        G_ON_PERM    = 3'd4,
        G_OFF_PERM   = 3'd5;

    reg [2:0] state, next_state;

    // Shift register to store last 3 x samples (oldest in MSB)
    reg [2:0] x_shift;

    // Flag indicating pattern detected (1,0,1)
    reg pattern_detected;

    // y monitor counter (counts from 0 to 2)
    reg [1:0] y_count;

    // Sequential block: state, outputs, x_shift, counters update
    always @(posedge clk) begin
        if (!resetn) begin
            state           <= IDLE;
            x_shift         <= 3'b000;
            pattern_detected<= 1'b0;
            y_count         <= 2'd0;
            f               <= 1'b0;
            g               <= 1'b0;
        end else begin
            // State update
            state <= next_state;

            // Shift in new x sample each clock in PATTERN_WAIT and after F_PULSE,
            // otherwise clear
            if (state == PATTERN_WAIT) begin
                // Shift left, insert newest x at LSB
                x_shift <= {x_shift[1:0], x};
            end else if (state == F_PULSE) begin
                // Clear shift register before starting pattern wait
                x_shift <= 3'b000;
            end else begin
                x_shift <= 3'b000;
            end

            // Pattern detected flag synchronous logic:
            // Only update when in PATTERN_WAIT state after shifting
            if (state == PATTERN_WAIT) begin
                pattern_detected <= ( {x_shift[1:0], x} == 3'b101 );
            end else begin
                pattern_detected <= 1'b0;
            end

            // y_count counter increments in Y_MONITOR only if y!=1; reset otherwise
            if (state == Y_MONITOR) begin
                if (y == 1'b1) begin
                    y_count <= 2'd0; // reset on y=1
                end else if (y_count < 2'd2) begin
                    y_count <= y_count + 1'b1;
                end else begin
                    y_count <= y_count; // Hold at 2
                end
            end else begin
                y_count <= 2'd0;
            end

            // Output f: pulse for one cycle in F_PULSE state only
            f <= (next_state == F_PULSE);

            // Output g:
            // g=1 during Y_MONITOR and G_ON_PERM, else 0
            // Because in G_OFF_PERM g=0 permanently
            if (next_state == Y_MONITOR || next_state == G_ON_PERM) begin
                g <= 1'b1;
            end else begin
                g <= 1'b0;
            end
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state; // default hold

        case(state)
            IDLE: begin
                // Wait in IDLE until resetn released
                if (resetn) begin
                    next_state = F_PULSE; // one clock cycle f=1 pulse
                end else begin
                    next_state = IDLE;
                end
            end

            F_PULSE: begin
                // After one cycle f=1, move to pattern detection
                next_state = PATTERN_WAIT;
            end

            PATTERN_WAIT: begin
                // Wait for pattern_detected flag
                if (pattern_detected) begin
                    next_state = Y_MONITOR;
                end else begin
                    next_state = PATTERN_WAIT;
                end
            end

            Y_MONITOR: begin
                // Monitor y input for at most two cycles
                if (y == 1'b1) begin
                    next_state = G_ON_PERM; // latch g=1 permanently
                end else if (y_count == 2'd2) begin
                    next_state = G_OFF_PERM; // latch g=0 permanently
                end else begin
                    next_state = Y_MONITOR;
                end
            end

            G_ON_PERM: begin
                // Hold g=1 permanently until reset
                next_state = G_ON_PERM;
            end

            G_OFF_PERM: begin
                // Hold g=0 permanently until reset
                next_state = G_OFF_PERM;
            end

            default: next_state = IDLE;
        endcase
    end

endmodule