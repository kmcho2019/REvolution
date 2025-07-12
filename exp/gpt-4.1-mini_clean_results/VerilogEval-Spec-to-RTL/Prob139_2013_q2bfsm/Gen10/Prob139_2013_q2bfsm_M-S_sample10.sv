module TopModule(
    input  wire clk,
    input  wire resetn,  // synchronous active low reset
    input  wire x,
    input  wire y,
    output wire f,
    output wire g
);

    // State encoding
    localparam IDLE         = 3'd0;
    localparam F_PULSE      = 3'd1;
    localparam PATTERN_DETECT=3'd2;
    localparam Y_WAIT       = 3'd3;
    localparam G_ON_PERM    = 3'd4;
    localparam G_OFF_PERM   = 3'd5;

    reg [2:0] state, next_state;

    // Shift register for last 3 x samples
    reg [2:0] x_shift, next_x_shift;

    // Counter for y monitoring (counts 0 and 1 for two cycles)
    reg [1:0] y_count, next_y_count;

    // Sequential logic with synchronous active-low reset
    always @(posedge clk) begin
        if (!resetn) begin
            state   <= IDLE;
            x_shift <= 3'd0;
            y_count <= 2'd0;
        end else begin
            state   <= next_state;
            x_shift <= next_x_shift;
            y_count <= next_y_count;
        end
    end

    // Next-state and internal signals logic
    always @(*) begin
        // Defaults: hold current values
        next_state   = state;
        next_x_shift = x_shift;
        next_y_count = y_count;

        case (state)
            IDLE: begin
                // Wait in IDLE while reset asserted
                // On resetn deasserted, move to F_PULSE
                if (resetn)
                    next_state = F_PULSE;
            end

            F_PULSE: begin
                // One cycle f=1, then move to PATTERN_DETECT
                next_state   = PATTERN_DETECT;
                next_x_shift = 3'd0;    // Clear shift register on entry
                next_y_count = 2'd0;
            end

            PATTERN_DETECT: begin
                // Shift in x to 3-bit register
                next_x_shift = {x_shift[1:0], x};

                // Check if last 3 bits are pattern 1,0,1
                if ({x_shift[1:0], x} == 3'b101) begin
                    next_state   = Y_WAIT;
                    next_y_count = 2'd0;
                end
            end

            Y_WAIT: begin
                // g=1 here; monitor y for up to two cycles (count 0 and 1)
                if (y == 1'b1) begin
                    next_state = G_ON_PERM;
                end else if (y_count == 2'd1) begin
                    // After 2 cycles with no y=1
                    next_state = G_OFF_PERM;
                end else begin
                    // Increment y_count and stay in Y_WAIT
                    next_y_count = y_count + 1'b1;
                end
            end

            G_ON_PERM: begin
                // g=1 permanently until reset
                // stay here indefinitely
                next_state = G_ON_PERM;
            end

            G_OFF_PERM: begin
                // g=0 permanently until reset
                // stay here indefinitely
                next_state = G_OFF_PERM;
            end

            default: begin
                // Safety fallback to IDLE
                next_state   = IDLE;
                next_x_shift = 3'd0;
                next_y_count = 2'd0;
            end
        endcase
    end

    // Moore outputs depend only on current state
    assign f = (state == F_PULSE);
    assign g = (state == Y_WAIT) || (state == G_ON_PERM);

endmodule