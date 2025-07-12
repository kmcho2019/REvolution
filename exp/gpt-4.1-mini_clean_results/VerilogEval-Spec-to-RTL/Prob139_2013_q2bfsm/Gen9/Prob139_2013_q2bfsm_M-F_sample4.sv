module TopModule(
    input  wire clk,
    input  wire resetn,  // synchronous active low reset
    input  wire x,
    input  wire y,
    output wire f,
    output wire g
);

    // FSM states as localparams for Verilog-2001 compatibility
    localparam IDLE         = 3'd0; // reset state
    localparam F_PULSE      = 3'd1; // output f=1 one clock cycle
    localparam PATTERN_WAIT = 3'd2; // shift and detect pattern 1,0,1 on x
    localparam Y_MONITOR    = 3'd3; // g=1, watch y for up to 2 cycles
    localparam G_ON_PERM    = 3'd4; // g=1 permanently
    localparam G_OFF_PERM   = 3'd5; // g=0 permanently

    reg [2:0] state, next_state;

    // 3-bit shift register for last 3 x samples
    reg [2:0] x_shift, next_x_shift;

    // Counter for y monitoring (0..1 to count exactly two cycles)
    reg [1:0] y_count, next_y_count;

    // Sequential logic: synchronous active-low reset
    always @(posedge clk) begin
        if (!resetn) begin
            state   <= IDLE;
            x_shift <= 3'b000;
            y_count <= 2'd0;
        end else begin
            state   <= next_state;
            x_shift <= next_x_shift;
            y_count <= next_y_count;
        end
    end

    // Combinational next state and internal signals logic
    always @(*) begin
        // Defaults: hold current values
        next_state   = state;
        next_x_shift = x_shift;
        next_y_count = y_count;

        case (state)
            IDLE: begin
                // While reset asserted (resetn=0), stay in IDLE
                // When resetn deasserted (1), move to F_PULSE
                if (resetn) begin
                    next_state   = F_PULSE;
                    next_x_shift = 3'b000;
                    next_y_count = 2'd0;
                end else begin
                    next_state   = IDLE;
                    next_x_shift = 3'b000;
                    next_y_count = 2'd0;
                end
            end

            F_PULSE: begin
                // Output f=1 one cycle
                // Then start pattern detection with empty shift register
                next_state   = PATTERN_WAIT;
                next_x_shift = 3'b000;
                next_y_count = 2'd0;
            end

            PATTERN_WAIT: begin
                // Shift left and insert new x at LSB
                next_x_shift = {x_shift[1:0], x};

                // Check for pattern 3'b101 (bits [2:0])
                // That is sequence 1,0,1 over three cycles on x
                if ({x_shift[1:0], x} == 3'b101) begin
                    next_state   = Y_MONITOR;
                    next_y_count = 2'd0;
                    next_x_shift = 3'b000; // no longer track x
                end else begin
                    next_state   = PATTERN_WAIT;
                    next_y_count = 2'd0;
                end
            end

            Y_MONITOR: begin
                // g=1 during this state
                // Monitor y input for up to 2 cycles (counts 0 and 1)
                // If y==1 at any cycle here, latch g=1 permanently
                if (y == 1'b1) begin
                    next_state   = G_ON_PERM;
                    next_y_count = 2'd0;
                    next_x_shift = 3'b000;
                end else if (y_count == 2'd1) begin
                    // Checked 2 cycles (count=0 then 1), y was never 1
                    next_state   = G_OFF_PERM;
                    next_y_count = 2'd0;
                    next_x_shift = 3'b000;
                end else begin
                    // Continue counting cycles in Y_MONITOR
                    next_state   = Y_MONITOR;
                    next_y_count = y_count + 1'b1;
                    next_x_shift = 3'b000;
                end
            end

            G_ON_PERM: begin
                // g=1 permanently until reset
                next_state   = G_ON_PERM;
                next_x_shift = 3'b000;
                next_y_count = 2'd0;
            end

            G_OFF_PERM: begin
                // g=0 permanently until reset
                next_state   = G_OFF_PERM;
                next_x_shift = 3'b000;
                next_y_count = 2'd0;
            end

            default: begin
                next_state   = IDLE;
                next_x_shift = 3'b000;
                next_y_count = 2'd0;
            end
        endcase
    end

    // Outputs depend only on current state (Moore outputs)
    assign f = (state == F_PULSE);
    assign g = (state == Y_MONITOR || state == G_ON_PERM);

endmodule