module TopModule(
    input  wire clk,
    input  wire resetn,  // synchronous active low reset
    input  wire x,
    input  wire y,
    output wire f,
    output wire g
);

    // Define FSM states
    typedef enum logic [2:0] {
        IDLE        = 3'd0, // reset state
        F_PULSE     = 3'd1, // output f=1 one clock cycle
        PATTERN_WAIT= 3'd2, // shift and detect pattern 1,0,1 on x
        Y_MONITOR   = 3'd3, // g=1, watch y for up to 2 cycles
        G_ON_PERM   = 3'd4, // g=1 permanently
        G_OFF_PERM  = 3'd5  // g=0 permanently
    } state_t;

    state_t state, next_state;

    // 3-bit shift register for last 3 x samples
    reg [2:0] x_shift, next_x_shift;

    // Counter for y monitoring (0..2)
    reg [1:0] y_count, next_y_count;

    // Sequential logic: synchronous reset active low
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

    // Combinational next state and internal signals logic
    always @(*) begin
        // Defaults: hold current values
        next_state    = state;
        next_x_shift  = x_shift;
        next_y_count  = y_count;

        case (state)
            IDLE: begin
                // Wait until reset released
                if (resetn)
                    next_state = F_PULSE;
                else
                    next_state = IDLE;
                next_x_shift = 3'b000;
                next_y_count = 2'd0;
            end

            F_PULSE: begin
                // Output f=1 one cycle, then start pattern detection
                next_state = PATTERN_WAIT;
                next_x_shift = 3'b000;
                next_y_count = 2'd0;
            end

            PATTERN_WAIT: begin
                // Shift in x
                next_x_shift = {x_shift[1:0], x};

                // Check pattern 3'b101 (x_shift[2],x_shift[1],x_shift[0])
                // Since shift left, latest x at bit 0
                // For example if last three x are: x_shift = [old2 old1 old0]
                // After shift: old1 old0 new_x
                // So pattern 1,0,1 corresponds to bits: [2]=1, [1]=0, [0]=1
                // So check if next_x_shift == 3'b101
                if ({x_shift[1:0], x} == 3'b101)
                    next_state = Y_MONITOR;
                else
                    next_state = PATTERN_WAIT;

                next_y_count = 2'd0;
            end

            Y_MONITOR: begin
                // g=1 during this state
                // Count cycles up to 2
                if (y == 1'b1) begin
                    next_state = G_ON_PERM; // latch g=1 permanently
                    next_y_count = 2'd0;
                end else if (y_count == 2'd2) begin
                    next_state = G_OFF_PERM; // latch g=0 permanently
                    next_y_count = 2'd0;
                end else begin
                    next_state = Y_MONITOR;
                    next_y_count = y_count + 1'b1;
                end
                next_x_shift = 3'b000; // no longer tracking x
            end

            G_ON_PERM: begin
                // g=1 forever until reset
                next_state = G_ON_PERM;
                next_x_shift = 3'b000;
                next_y_count = 2'd0;
            end

            G_OFF_PERM: begin
                // g=0 forever until reset
                next_state = G_OFF_PERM;
                next_x_shift = 3'b000;
                next_y_count = 2'd0;
            end

            default: begin
                // fallback to IDLE
                next_state = IDLE;
                next_x_shift = 3'b000;
                next_y_count = 2'd0;
            end
        endcase
    end

    // Moore outputs based on state only
    assign f = (state == F_PULSE);
    assign g = (state == Y_MONITOR || state == G_ON_PERM);

endmodule