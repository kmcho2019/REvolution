module TopModule(
    input  wire clk,
    input  wire resetn,  // synchronous active low reset
    input  wire x,
    input  wire y,
    output wire f,
    output wire g
);

    // FSM states encoding
    localparam IDLE         = 3'd0;
    localparam F_PULSE      = 3'd1;
    localparam PATTERN_WAIT = 3'd2;
    localparam G_PULSE      = 3'd3;
    localparam Y_MONITOR    = 3'd4;
    localparam G_ON_PERM    = 3'd5;
    localparam G_OFF_PERM   = 3'd6;

    reg [2:0] state, next_state;

    // Shift register for x samples
    // We'll store the last 3 samples of x in order: oldest at bit 2, newest at bit 0
    reg [2:0] x_shift, next_x_shift;

    // Counter for y monitoring (counts 0..2 cycles)
    reg [1:0] y_count, next_y_count;

    // Sequential logic: synchronous active low reset
    always @(posedge clk) begin
        if (!resetn) begin
            state    <= IDLE;
            x_shift  <= 3'b000;
            y_count  <= 2'd0;
        end else begin
            state    <= next_state;
            x_shift  <= next_x_shift;
            y_count  <= next_y_count;
        end
    end

    // Combinational logic for next state and internal registers
    always @(*) begin
        // Defaults: hold current values
        next_state   = state;
        next_x_shift = x_shift;
        next_y_count = y_count;

        case (state)
            IDLE: begin
                // Stay here while reset asserted (resetn==0)
                // Once resetn goes high, go to F_PULSE to assert f=1 for one cycle
                if (resetn) begin
                    next_state   = F_PULSE;
                    next_x_shift = 3'b000; // clear shift register
                    next_y_count = 2'd0;
                end else begin
                    next_state = IDLE;
                    next_x_shift = 3'b000;
                    next_y_count = 2'd0;
                end
            end

            F_PULSE: begin
                // f=1 for exactly one cycle after reset release
                // then go to PATTERN_WAIT for pattern detection
                next_state   = PATTERN_WAIT;
                next_x_shift = 3'b000; // clear shift register before starting pattern
                next_y_count = 2'd0;
            end

            PATTERN_WAIT: begin
                // Shift in new x sample on each clock cycle
                // x_shift = {oldest, ..., newest} with newest at bit 0
                next_x_shift = {x_shift[1:0], x};

                // Check if the last 3 samples equal pattern 1,0,1 (bits 2..0 = 3'b101)
                // When detected, go to G_PULSE to assert g=1 for one cycle
                if ({x_shift[1:0], x} == 3'b101) begin
                    next_state = G_PULSE;
                    next_y_count = 2'd0;
                end else begin
                    next_state = PATTERN_WAIT;
                    next_y_count = 2'd0;
                end
            end

            G_PULSE: begin
                // g=1 for exactly one clock cycle immediately after detecting pattern
                // then move to Y_MONITOR to monitor y input while maintaining g=1
                next_state = Y_MONITOR;
                next_y_count = 2'd0;
                next_x_shift = 3'b000; // no longer need x_shift here
            end

            Y_MONITOR: begin
                // g=1 while monitoring y for up to 2 cycles
                if (y == 1'b1) begin
                    // y=1 detected within allowed 2 cycles: latch g=1 permanently
                    next_state = G_ON_PERM;
                    next_y_count = 2'd0;
                end else if (y_count == 2'd1) begin
                    // After two cycles without seeing y=1, latch g=0 permanently
                    next_state = G_OFF_PERM;
                    next_y_count = 2'd0;
                end else begin
                    // Continue monitoring y, increment count
                    next_state = Y_MONITOR;
                    next_y_count = y_count + 1'b1;
                end
                next_x_shift = 3'b000; // not used here
            end

            G_ON_PERM: begin
                // g=1 permanently until reset
                next_state = G_ON_PERM;
                next_x_shift = 3'b000;
                next_y_count = 2'd0;
            end

            G_OFF_PERM: begin
                // g=0 permanently until reset
                next_state = G_OFF_PERM;
                next_x_shift = 3'b000;
                next_y_count = 2'd0;
            end

            default: begin
                // safe fallback state
                next_state = IDLE;
                next_x_shift = 3'b000;
                next_y_count = 2'd0;
            end
        endcase
    end

    // Moore outputs: depend only on current state
    assign f = (state == F_PULSE);
    assign g = (state == G_PULSE) || (state == Y_MONITOR) || (state == G_ON_PERM);

endmodule