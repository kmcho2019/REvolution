module TopModule (
    input  wire clk,
    input  wire resetn,  // synchronous active low reset
    input  wire x,
    input  wire y,
    output wire f,
    output wire g
);

    // One-hot state encoding (7 states)
    localparam A        = 7'b000_0001;  // Reset state
    localparam F_PULSE  = 7'b000_0010;
    localparam PAT_WAIT = 7'b000_0100;
    localparam G_PULSE  = 7'b000_1000;
    localparam Y_MON    = 7'b001_0000;
    localparam G_ON     = 7'b010_0000;
    localparam G_OFF    = 7'b100_0000;

    reg [6:0] state, next_state;

    // Shift register to capture last 3 x samples (MSB oldest)
    reg [2:0] x_shift;

    // Y monitor cycle counter (counts 0,1 for two cycles max)
    reg [1:0] y_count, next_y_count;

    // Sequential logic: state, x_shift, y_count updates with synchronous active-low reset
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

    // Next state and y_count combinational logic
    always @(*) begin
        // Defaults to hold state and counter
        next_state   = state;
        next_y_count = y_count;

        case (1'b1)
            state[A]: begin
                if (resetn)
                    next_state = F_PULSE;
                else
                    next_state = A;
                next_y_count = 2'd0;
            end

            state[F_PULSE]: begin
                // F pulse one cycle, then go to pattern wait
                next_state = PAT_WAIT;
                next_y_count = 2'd0;
            end

            state[PAT_WAIT]: begin
                // Wait for pattern 101 on x_shift
                // x_shift updated synchronously, so pattern detected immediately when matching
                if (x_shift == 3'b101)
                    next_state = G_PULSE;
                else
                    next_state = PAT_WAIT;
                next_y_count = 2'd0;
            end

            state[G_PULSE]: begin
                // G pulse one cycle, then monitor y
                next_state = Y_MON;
                next_y_count = 2'd0;
            end

            state[Y_MON]: begin
                if (y == 1'b1) begin
                    next_state = G_ON;
                    next_y_count = 2'd0;
                end else if (y_count == 2'd1) begin
                    // waited two cycles (counts 0 and 1)
                    next_state = G_OFF;
                    next_y_count = 2'd0;
                end else begin
                    next_state = Y_MON;
                    next_y_count = y_count + 1'b1;
                end
            end

            state[G_ON]: begin
                // Hold g=1 permanently until reset
                next_state = G_ON;
                next_y_count = 2'd0;
            end

            state[G_OFF]: begin
                // Hold g=0 permanently until reset
                next_state = G_OFF;
                next_y_count = 2'd0;
            end

            default: begin
                next_state = A;
                next_y_count = 2'd0;
            end
        endcase
    end

    // Outputs are combinational based on current state
    // f = 1 only in F_PULSE state for one clock cycle after reset
    assign f = (state == F_PULSE);

    // g = 1 only in G_PULSE (1 cycle), Y_MON (monitoring, also g=1 during wait),
    // and G_ON (permanent g=1). The problem states g=1 for one cycle after pattern detected,
    // then monitor y while maintaining g=1, then permanently hold g as 1 or 0.
    assign g = (state == G_PULSE) || (state == Y_MON) || (state == G_ON);

endmodule