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
    localparam Y_MONITOR    = 3'd3;
    localparam G_ON_PERM    = 3'd4;
    localparam G_OFF_PERM   = 3'd5;

    reg [2:0] state, next_state;

    // 3-bit shift register for x: bits [2:0] hold last 3 samples with newest at bit 0 (LSB)
    // After shift: x_shift <= {x_shift[1:0], x};
    // So bit 2 = oldest, bit 0 = newest
    reg [2:0] x_shift, next_x_shift;

    // Counter for y monitoring (0..2)
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
        // Defaults: hold current
        next_state   = state;
        next_x_shift = x_shift;
        next_y_count = y_count;

        case (state)
            IDLE: begin
                // Stay in IDLE while resetn is low
                if (resetn)
                    next_state = F_PULSE; // one cycle f=1
                else
                    next_state = IDLE;
                next_x_shift = 3'b000;
                next_y_count = 2'd0;
            end

            F_PULSE: begin
                // f=1 one clock cycle, then start pattern detection
                next_state = PATTERN_WAIT;
                next_x_shift = 3'b000; // reset shift register
                next_y_count = 2'd0;
            end

            PATTERN_WAIT: begin
                // Shift in new x sample at bit 0 (LSB), oldest at bit 2 (MSB)
                // New shift register value:
                next_x_shift = {x_shift[1:0], x};

                // Check pattern 1,0,1: bits {2,1,0} = 3'b101
                if ( {x_shift[1:0], x} == 3'b101 )
                    next_state = Y_MONITOR;
                else
                    next_state = PATTERN_WAIT;

                next_y_count = 2'd0;
            end

            Y_MONITOR: begin
                // g=1 in this state
                // Count number of cycles in this state up to 2
                // y_count counts how many cycles have passed without seeing y=1
                if (y == 1'b1) begin
                    // y=1 detected within allowed cycles: latch g=1 permanently
                    next_state = G_ON_PERM;
                    next_y_count = 2'd0;
                end else if (y_count == 2'd1) begin
                    // After waiting two cycles (counts 0 and 1), and y still zero
                    // Move to g=0 permanently
                    next_state = G_OFF_PERM;
                    next_y_count = 2'd0;
                end else begin
                    // Continue monitoring y
                    next_state = Y_MONITOR;
                    next_y_count = y_count + 1'b1;
                end

                next_x_shift = 3'b000; // no longer used here
            end

            G_ON_PERM: begin
                // g=1 permanently
                next_state = G_ON_PERM;
                next_x_shift = 3'b000;
                next_y_count = 2'd0;
            end

            G_OFF_PERM: begin
                // g=0 permanently
                next_state = G_OFF_PERM;
                next_x_shift = 3'b000;
                next_y_count = 2'd0;
            end

            default: begin
                // safe default
                next_state = IDLE;
                next_x_shift = 3'b000;
                next_y_count = 2'd0;
            end
        endcase
    end

    // Moore outputs depend only on current state
    assign f = (state == F_PULSE);
    assign g = (state == Y_MONITOR) || (state == G_ON_PERM);

endmodule