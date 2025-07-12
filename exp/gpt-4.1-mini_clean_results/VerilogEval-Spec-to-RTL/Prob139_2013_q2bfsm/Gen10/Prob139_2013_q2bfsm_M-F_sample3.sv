module TopModule(
    input  wire clk,
    input  wire resetn,  // synchronous active low reset
    input  wire x,
    input  wire y,
    output wire f,
    output wire g
);

    // FSM states
    localparam IDLE         = 3'd0; // reset state A
    localparam F_PULSE      = 3'd1; // f=1 for one clock cycle
    localparam PATTERN_WAIT = 3'd2; // waiting for pattern 1,0,1 on x
    localparam Y_MONITOR    = 3'd3; // g=1, monitor y for up to 2 cycles
    localparam G_ON_PERM    = 3'd4; // g=1 permanently
    localparam G_OFF_PERM   = 3'd5; // g=0 permanently

    reg [2:0] state, next_state;

    // Shift register for last 3 samples of x, updated on clock
    reg [2:0] x_shift;

    // Counter for y monitoring cycles (0..1)
    reg [1:0] y_count, next_y_count;

    // Sequential block: synchronous reset and state updates
    always @(posedge clk) begin
        if (!resetn) begin
            state   <= IDLE;
            x_shift <= 3'b000;
            y_count <= 2'd0;
        end else begin
            state   <= next_state;

            // Update shift register only in PATTERN_WAIT, else clear
            if (next_state == PATTERN_WAIT)
                x_shift <= {x_shift[1:0], x};
            else
                x_shift <= 3'b000;

            y_count <= next_y_count;
        end
    end

    // Next state and y_count combinational logic
    always @(*) begin
        next_state = state;
        next_y_count = y_count;

        case(state)
            IDLE: begin
                // Stay in IDLE while reset asserted (resetn=0) handled in sequential block
                // When out of reset, move to F_PULSE on next clock
                next_state = F_PULSE;
                next_y_count = 2'd0;
            end

            F_PULSE: begin
                // f=1 one clock cycle, then move to pattern wait
                next_state = PATTERN_WAIT;
                next_y_count = 2'd0;
            end

            PATTERN_WAIT: begin
                // Pattern detection on updated x_shift (shifted in sequential block)
                // Check if x_shift == 3'b101 (pattern 1,0,1)
                if (x_shift == 3'b101) begin
                    next_state = Y_MONITOR;
                    next_y_count = 2'd0;
                end else begin
                    next_state = PATTERN_WAIT;
                    next_y_count = 2'd0;
                end
            end

            Y_MONITOR: begin
                // g=1 during Y_MONITOR
                if (y == 1'b1) begin
                    // y detected within allowed time, latch g=1 permanently
                    next_state = G_ON_PERM;
                    next_y_count = 2'd0;
                end else if (y_count == 2'd1) begin
                    // Two cycles elapsed, y never 1, latch g=0 permanently
                    next_state = G_OFF_PERM;
                    next_y_count = 2'd0;
                end else begin
                    // Increment y_count to track cycles
                    next_state = Y_MONITOR;
                    next_y_count = y_count + 1'b1;
                end
            end

            G_ON_PERM: begin
                // Remain here until reset
                next_state = G_ON_PERM;
                next_y_count = 2'd0;
            end

            G_OFF_PERM: begin
                // Remain here until reset
                next_state = G_OFF_PERM;
                next_y_count = 2'd0;
            end

            default: begin
                next_state = IDLE;
                next_y_count = 2'd0;
            end
        endcase
    end

    // Outputs depend only on current state
    assign f = (state == F_PULSE);
    assign g = (state == Y_MONITOR || state == G_ON_PERM);

endmodule