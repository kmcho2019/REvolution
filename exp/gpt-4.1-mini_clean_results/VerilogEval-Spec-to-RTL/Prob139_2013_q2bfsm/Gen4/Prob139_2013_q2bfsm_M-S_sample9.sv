module TopModule(
    input  clk,
    input  resetn,
    input  x,
    input  y,
    output reg f,
    output reg g
);

    // State encoding
    typedef enum logic [2:0] {
        IDLE       = 3'd0, // State A: waiting for reset release
        F_PULSE    = 3'd1, // Assert f=1 for 1 clock cycle
        SEQ_DETECT = 3'd2, // Detect sequence 1,0,1 on input x
        MONITOR_Y  = 3'd3, // Monitor y input for up to 2 cycles while g=1
        G_ON       = 3'd4, // Permanently g=1
        G_OFF      = 3'd5  // Permanently g=0
    } state_t;

    state_t state, next_state;

    // Shift register for x input sequence detection (to check last 3 bits)
    reg [2:0] x_shift;

    // Counter for y monitoring (0,1,2)
    reg [1:0] y_count;

    // State register
    always @(posedge clk) begin
        if (!resetn) begin
            state <= IDLE;
            x_shift <= 3'b000;
            y_count <= 2'd0;
        end else begin
            state <= next_state;

            // Shift x input for sequence detection in SEQ_DETECT state only
            if (state == SEQ_DETECT) begin
                x_shift <= {x_shift[1:0], x};
            end else begin
                x_shift <= 3'b000; // reset shift register outside detection state
            end

            // Count cycles monitoring y in MONITOR_Y state
            if (state == MONITOR_Y) begin
                y_count <= y_count + 1'b1;
            end else begin
                y_count <= 2'd0;
            end
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state; // default hold

        case (state)
            IDLE: begin
                if (resetn)
                    next_state = F_PULSE;
            end

            F_PULSE: begin
                // After asserting f once, start sequence detection on x
                next_state = SEQ_DETECT;
            end

            SEQ_DETECT: begin
                // Check if last 3 bits of x_shift equal pattern 1,0,1
                // x_shift[2] = oldest, x_shift[0] = newest
                if (x_shift == 3'b101)
                    next_state = MONITOR_Y;
                else
                    next_state = SEQ_DETECT; // keep shifting and checking
            end

            MONITOR_Y: begin
                // g=1 asserted, monitoring y input up to 2 cycles
                if (y == 1'b1)
                    next_state = G_ON; // y=1 detected within window
                else if (y_count == 2'd1) // after 2 cycles (counting 0 and 1)
                    next_state = G_OFF; // y not detected in time
                else
                    next_state = MONITOR_Y; // continue monitoring
            end

            G_ON: begin
                // Permanently g=1 until reset
                next_state = G_ON;
            end

            G_OFF: begin
                // Permanently g=0 until reset
                next_state = G_OFF;
            end

            default: next_state = IDLE;
        endcase
    end

    // Output logic (Moore outputs)
    always @(posedge clk) begin
        if (!resetn) begin
            f <= 1'b0;
            g <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    f <= 1'b0;
                    g <= 1'b0;
                end

                F_PULSE: begin
                    f <= 1'b1;
                    g <= 1'b0;
                end

                SEQ_DETECT: begin
                    f <= 1'b0;
                    g <= 1'b0;
                end

                MONITOR_Y: begin
                    f <= 1'b0;
                    g <= 1'b1;
                end

                G_ON: begin
                    f <= 1'b0;
                    g <= 1'b1;
                end

                G_OFF: begin
                    f <= 1'b0;
                    g <= 1'b0;
                end

                default: begin
                    f <= 1'b0;
                    g <= 1'b0;
                end
            endcase
        end
    end

endmodule