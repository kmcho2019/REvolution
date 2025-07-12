module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

    // State encoding: 3 bits enough for 5 states
    localparam IDLE       = 3'd0; // Wait for resetn deassertion
    localparam F_PULSE    = 3'd1; // Assert f=1 for one clock cycle after reset deassertion
    localparam WAIT_PATTERN = 3'd2; // Detect pattern 1,0,1 on x (via shift register)
    localparam MONITOR_Y  = 3'd3; // g=1 active, monitor y input for 2 cycles max
    localparam G_ON_PERM  = 3'd4; // Permanently g=1
    localparam G_OFF_PERM = 3'd5; // Permanently g=0

    reg [2:0] state, next_state;

    // Shift register to hold last 3 samples of x for pattern detection
    reg [2:0] x_shift;

    // 2-bit counter to count y monitor cycles (0 to 2)
    reg [1:0] y_count;

    // Synchronous sequential logic: state, shift reg, counter
    always @(posedge clk) begin
        if (!resetn) begin
            state <= IDLE;
            x_shift <= 3'b000;
            y_count <= 2'b00;
        end else begin
            state <= next_state;

            // Update shift register only in WAIT_PATTERN state
            if (state == WAIT_PATTERN) begin
                x_shift <= {x_shift[1:0], x};
            end else begin
                x_shift <= 3'b000; // Clear outside pattern detection
            end

            // Update y_count in MONITOR_Y
            if (state == MONITOR_Y) begin
                y_count <= y_count + 1;
            end else begin
                y_count <= 2'b00;
            end
        end
    end

    // Combinational logic for next state and outputs
    always @(*) begin
        // Default outputs
        f = 1'b0;
        g = 1'b0;
        next_state = state;

        case (state)
            IDLE: begin
                // Stay here while resetn is 0 (sync reset)
                // When resetn deasserted, move to F_PULSE
                if (resetn)
                    next_state = F_PULSE;
                else
                    next_state = IDLE;
                // f and g stay 0
            end

            F_PULSE: begin
                // Assert f=1 for one cycle
                f = 1'b1;
                g = 1'b0;
                // Then move to pattern detection
                next_state = WAIT_PATTERN;
            end

            WAIT_PATTERN: begin
                // f=0, g=0 during pattern detection
                f = 1'b0;
                g = 1'b0;
                // Update next_state depends on x_shift
                // After first two samples, x_shift will contain partial pattern
                // We check after shift reg updates each clock

                // If x_shift == 3'b101 then pattern matched
                if (x_shift == 3'b101)
                    next_state = MONITOR_Y;
                else
                    next_state = WAIT_PATTERN; // Keep sampling

                // Pattern detection restarts automatically as shift reg slides
            end

            MONITOR_Y: begin
                // g=1 while monitoring y for max 2 cycles
                f = 1'b0;
                g = 1'b1;

                // If y=1 anytime here, move to permanent g=1 state
                // Else after 2 cycles, move to permanent g=0 state
                if (y == 1'b1)
                    next_state = G_ON_PERM;
                else if (y_count == 2'd1) // Because counter increments after clk edge, count from 0 so when count==1 means 2 cycles done
                    next_state = G_OFF_PERM;
                else
                    next_state = MONITOR_Y;
            end

            G_ON_PERM: begin
                // Permanently hold g=1 until reset
                f = 1'b0;
                g = 1'b1;
                next_state = G_ON_PERM;
            end

            G_OFF_PERM: begin
                // Permanently hold g=0 until reset
                f = 1'b0;
                g = 1'b0;
                next_state = G_OFF_PERM;
            end

            default: begin
                // Safety fallback to IDLE
                f = 1'b0;
                g = 1'b0;
                next_state = IDLE;
            end
        endcase
    end

endmodule