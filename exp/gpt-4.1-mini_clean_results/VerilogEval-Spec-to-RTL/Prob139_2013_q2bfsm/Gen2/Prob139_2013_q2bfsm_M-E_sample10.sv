module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

    // FSM States
    localparam IDLE        = 2'd0;
    localparam F_ASSERT    = 2'd1;
    localparam G_MONITOR   = 2'd2;
    localparam G_PERM      = 2'd3; // g permanently 1 or 0, distinguished by g reg

    reg [1:0] state, next_state;

    // Shift register to hold last 3 samples of x
    reg [2:0] x_shift;

    // Counter to track y monitoring cycles (0,1,2)
    reg [1:0] y_cnt;

    // Flag to indicate if pattern 1-0-1 detected
    wire pattern_detected;
    assign pattern_detected = (x_shift == 3'b101);

    // Sequential state and registers update
    always @(posedge clk) begin
        if (~resetn) begin
            state <= IDLE;
            f <= 1'b0;
            g <= 1'b0;
            x_shift <= 3'b000;
            y_cnt <= 2'd0;
        end else begin
            state <= next_state;

            // Shift in current x sample every cycle except during reset
            x_shift <= {x_shift[1:0], x};

            case (state)
                IDLE: begin
                    f <= 1'b0;
                    g <= 1'b0;
                    y_cnt <= 2'd0;
                end

                F_ASSERT: begin
                    // Assert f for one cycle after reset de-asserted
                    f <= 1'b1;
                    g <= 1'b0;
                    y_cnt <= 2'd0;
                end

                G_MONITOR: begin
                    f <= 1'b0;
                    g <= 1'b1;
                    // Increment y monitoring counter
                    y_cnt <= y_cnt + 1'b1;

                    // If y=1 detected, transition to permanent g=1
                    // Else, if counter reaches 2 without y=1, go permanent g=0
                    if (y == 1'b1) begin
                        // g=1 permanently
                        // y_cnt not important anymore
                    end
                end

                G_PERM: begin
                    // Permanently held g and f=0
                    f <= 1'b0;
                    // g holds its last value
                    y_cnt <= 2'd0;
                end

                default: begin
                    f <= 1'b0;
                    g <= 1'b0;
                    y_cnt <= 2'd0;
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (resetn)
                    next_state = F_ASSERT;
                else
                    next_state = IDLE;
            end

            F_ASSERT: begin
                next_state = G_MONITOR;
            end

            G_MONITOR: begin
                // If y=1 within 2 cycles, go to G_PERM with g=1
                if (y == 1'b1) begin
                    next_state = G_PERM;
                end else if (y_cnt == 2'd1) begin
                    // y_cnt increments after one cycle, so if after next cycle still no y=1,
                    // then move to permanent g=0
                    next_state = G_PERM;
                end else begin
                    next_state = G_MONITOR;
                end
            end

            G_PERM: begin
                // Stay here until reset
                next_state = G_PERM;
            end

            default: next_state = IDLE;
        endcase
    end

    // Logic to update g in G_PERM
    always @(posedge clk) begin
        if (~resetn) begin
            // already handled in main sequential block
        end else if (state == G_MONITOR) begin
            // keep g=1 during monitoring
            g <= 1'b1;
        end else if (state == G_PERM) begin
            if (y == 1'b1 || y_cnt < 2'd2) begin
                // If y=1 happened or we entered perm due to y=1, keep g=1
                g <= 1'b1;
            end else begin
                // Else g=0 permanently
                g <= 1'b0;
            end
        end else if (state == F_ASSERT || state == IDLE) begin
            g <= 1'b0;
        end
    end

    // We must detect the pattern 1,0,1 on x continuously in G_MONITOR.
    // To do so, reset the monitoring cycle only after pattern is detected.
    // But FSM states do not differentiate pattern detection, so we encode pattern detection
    // outside FSM states to trigger transition from F_ASSERT to G_MONITOR only after pattern detected.

    // Hence, refine next_state logic:
    // Actually, in problem, after F_ASSERT (f=1 one cycle), FSM must monitor x input and wait for pattern 1,0,1.
    // Once pattern detected, set g=1 and start y monitoring.

    // So, modify next state logic and sequencing to:
    // IDLE --reset de-asserted--> F_ASSERT --next--> WAIT_PATTERN --when pattern detected--> G_MONITOR --...
    // Implement WAIT_PATTERN state for waiting pattern detection.

endmodule