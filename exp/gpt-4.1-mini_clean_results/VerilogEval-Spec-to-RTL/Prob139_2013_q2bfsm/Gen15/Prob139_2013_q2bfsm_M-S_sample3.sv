module TopModule (
    input  wire clk,
    input  wire resetn,  // synchronous active low reset
    input  wire x,
    input  wire y,
    output wire f,
    output wire g
);

    // State encoding
    localparam [2:0]
        A          = 3'd0, // reset state
        F_PULSE    = 3'd1,
        WAIT_PATTERN=3'd2,
        G_PULSE    = 3'd3,
        Y_MONITOR  = 3'd4,
        G_ON       = 3'd5,
        G_OFF      = 3'd6;

    reg [2:0] state, next_state;

    // Shift register for last 3 samples of x
    reg [2:0] x_shift;

    // Counter for Y_MONITOR (0 or 1 to count up to two cycles)
    reg [1:0] y_count, next_y_count;

    // Sequential logic: state, x_shift, y_count update
    always @(posedge clk) begin
        if (!resetn) begin
            state   <= A;
            x_shift <= 3'b000;
            y_count <= 2'd0;
        end else begin
            state   <= next_state;
            x_shift <= {x_shift[1:0], x};
            y_count <= next_y_count;
        end
    end

    // Next state and y_count logic
    always @(*) begin
        // Defaults
        next_state   = state;
        next_y_count = y_count;

        case(state)
            A: begin
                if (resetn)
                    next_state = F_PULSE;
                else
                    next_state = A;
                next_y_count = 2'd0;
            end

            F_PULSE: begin
                // Assert f=1 one cycle, then go wait for pattern
                next_state   = WAIT_PATTERN;
                next_y_count = 2'd0;
            end

            WAIT_PATTERN: begin
                // Wait until x_shift == 3'b101 pattern detected
                if (x_shift == 3'b101)
                    next_state = G_PULSE;
                else
                    next_state = WAIT_PATTERN;
                next_y_count = 2'd0;
            end

            G_PULSE: begin
                // Assert g=1 one cycle, then start monitoring y
                next_state   = Y_MONITOR;
                next_y_count = 2'd0;
            end

            Y_MONITOR: begin
                if (y == 1'b1) begin
                    next_state = G_ON; // hold g=1 forever
                    next_y_count = 2'd0;
                end else if (y_count == 2'd1) begin
                    // 2 cycles elapsed without y=1
                    next_state = G_OFF; // hold g=0 forever
                    next_y_count = 2'd0;
                end else begin
                    next_state = Y_MONITOR;
                    next_y_count = y_count + 1'b1;
                end
            end

            G_ON: begin
                next_state   = G_ON;
                next_y_count = 2'd0;
            end

            G_OFF: begin
                next_state   = G_OFF;
                next_y_count = 2'd0;
            end

            default: begin
                next_state   = A;
                next_y_count = 2'd0;
            end
        endcase
    end

    // Moore outputs
    assign f = (state == F_PULSE);
    assign g = (state == G_PULSE) || (state == Y_MONITOR) || (state == G_ON);

endmodule