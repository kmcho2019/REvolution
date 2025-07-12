module TopModule (
    input  wire clk,
    input  wire resetn,  // synchronous active low reset
    input  wire x,
    input  wire y,
    output wire f,
    output wire g
);

    // One-hot encoded states
    localparam A_IDLE    = 7'b0000001;
    localparam A_F_PULSE = 7'b0000010;
    localparam A_PATTERN = 7'b0000100;
    localparam A_G_PULSE = 7'b0001000;
    localparam A_Y_MON   = 7'b0010000;
    localparam A_G_ON    = 7'b0100000;
    localparam A_G_OFF   = 7'b1000000;

    reg [6:0] state, next_state;

    // Shift register to hold last 3 x samples: oldest bit 2, newest bit 0
    reg [2:0] x_shift, next_x_shift;

    // Counter for Y monitor (0 to 2)
    reg [1:0] y_count, next_y_count;

    // Sequential logic: state, x_shift, y_count registers with synchronous active low reset
    always @(posedge clk) begin
        if (!resetn) begin
            state     <= A_IDLE;
            x_shift   <= 3'b000;
            y_count   <= 2'd0;
        end else begin
            state     <= next_state;
            x_shift   <= next_x_shift;
            y_count   <= next_y_count;
        end
    end

    // Combinational next state and register logic
    always @(*) begin
        // Default assignments to hold current values
        next_state   = state;
        next_x_shift = x_shift;
        next_y_count = y_count;

        case (state)
            A_IDLE: begin
                // Wait for reset release to start sequence
                if (resetn) begin
                    next_state   = A_F_PULSE;
                    next_x_shift = 3'b000;
                    next_y_count = 2'd0;
                end else begin
                    next_state   = A_IDLE;
                    next_x_shift = 3'b000;
                    next_y_count = 2'd0;
                end
            end

            A_F_PULSE: begin
                // Assert f=1 for one clock cycle, then go to pattern detect
                next_state   = A_PATTERN;
                next_x_shift = 3'b000;  // clear shift register before pattern detection
                next_y_count = 2'd0;
            end

            A_PATTERN: begin
                // Shift in new x sample
                // oldest bit 2 shifts out, new sample goes into bit 0
                next_x_shift = {x_shift[1:0], x};

                // Check if the registered last 3 samples match 1,0,1 (bit2=1, bit1=0, bit0=1)
                // Use x_shift (already updated with current x sample) to detect pattern
                // Since we updated next_x_shift = {x_shift[1:0], x}, pattern check should be done on next_x_shift
                // To get correct timing, delay pattern detection by one cycle:
                // Detect pattern on current x_shift value (which holds last 3 samples including previous x inputs)
                // This corresponds to the pattern that appeared at previous cycle.
                if (x_shift == 3'b101) begin
                    next_state   = A_G_PULSE;
                    next_y_count = 2'd0;
                end else begin
                    next_state   = A_PATTERN;
                    next_y_count = 2'd0;
                end
            end

            A_G_PULSE: begin
                // Assert g=1 for one clock cycle then move to y monitoring
                next_state   = A_Y_MON;
                next_x_shift = 3'b000; // reset shift register no longer needed
                next_y_count = 2'd0;
            end

            A_Y_MON: begin
                // Keep g=1 while monitoring y for at most 2 clock cycles
                if (y == 1'b1) begin
                    // y=1 detected within allowed window => g=1 permanent
                    next_state   = A_G_ON;
                    next_y_count = 2'd0;
                end else if (y_count == 2'd2) begin
                    // 2 cycles elapsed without y=1 => g=0 permanent
                    next_state   = A_G_OFF;
                    next_y_count = 2'd0;
                end else begin
                    // Continue monitoring, increment y_count
                    next_state   = A_Y_MON;
                    next_y_count = y_count + 1'b1;
                end
                next_x_shift = 3'b000; // unused here
            end

            A_G_ON: begin
                // g=1 permanently until reset
                next_state   = A_G_ON;
                next_x_shift = 3'b000;
                next_y_count = 2'd0;
            end

            A_G_OFF: begin
                // g=0 permanently until reset
                next_state   = A_G_OFF;
                next_x_shift = 3'b000;
                next_y_count = 2'd0;
            end

            default: begin
                // Safe fallback to idle
                next_state   = A_IDLE;
                next_x_shift = 3'b000;
                next_y_count = 2'd0;
            end
        endcase
    end

    // Outputs are Moore outputs depending only on state bits
    assign f = (state == A_F_PULSE);
    assign g = (state == A_G_PULSE) || (state == A_Y_MON) || (state == A_G_ON);

endmodule