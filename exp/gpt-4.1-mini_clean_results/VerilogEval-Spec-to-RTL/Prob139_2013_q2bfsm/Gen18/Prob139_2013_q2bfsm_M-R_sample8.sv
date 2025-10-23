module TopModule(
    input  wire clk,
    input  wire resetn,  // synchronous active low reset
    input  wire x,
    input  wire y,
    output wire f,
    output wire g
);

    // State encoding (binary)
    localparam [3:0]
        A            = 4'd0,  // reset state
        F_PULSE      = 4'd1,  // f=1 one cycle after reset deassertion
        WAIT_PATTERN = 4'd2,  // monitor x input for pattern 101
        G_PULSE      = 4'd3,  // g=1 one cycle pulse after pattern found
        MONITOR_Y_0  = 4'd4,  // monitor y cycle 0 (g=1)
        MONITOR_Y_1  = 4'd5,  // monitor y cycle 1 (g=1)
        G_ON         = 4'd6,  // g=1 permanent
        G_OFF        = 4'd7;  // g=0 permanent

    reg [3:0] state, next_state;

    // Shift register for x input samples (3 bits)
    reg [2:0] x_shift;
    // Counter to track how many samples of x have been received (max 3)
    reg [1:0] x_sample_count;

    // State register update with synchronous active low reset
    always @(posedge clk) begin
        if (!resetn) begin
            state          <= A;
            x_shift        <= 3'b000;
            x_sample_count <= 2'd0;
        end else begin
            state <= next_state;
            // Update x_shift and sample count only if currently in WAIT_PATTERN
            if (state == WAIT_PATTERN) begin
                x_shift <= {x_shift[1:0], x};
                if (x_sample_count < 2'd3)
                    x_sample_count <= x_sample_count + 1'b1;
            end else begin
                // Reset shift register and sample count when not monitoring pattern
                x_shift        <= 3'b000;
                x_sample_count <= 2'd0;
            end
        end
    end

    // Next state combinational logic
    always @(*) begin
        next_state = state; // default hold
        case (state)
            A: begin
                if (resetn)
                    next_state = F_PULSE;
                else
                    next_state = A;
            end
            F_PULSE: begin
                // after outputting f=1, move to wait pattern
                next_state = WAIT_PATTERN;
            end
            WAIT_PATTERN: begin
                // Check pattern only after at least 3 samples
                if ((x_sample_count >= 2'd3) && (x_shift == 3'b101))
                    next_state = G_PULSE;
                else
                    next_state = WAIT_PATTERN;
            end
            G_PULSE: begin
                // One cycle g=1 pulse, then monitor y for 2 cycles
                next_state = MONITOR_Y_0;
            end
            MONITOR_Y_0: begin
                if (y == 1'b1)
                    next_state = G_ON;
                else
                    next_state = MONITOR_Y_1;
            end
            MONITOR_Y_1: begin
                if (y == 1'b1)
                    next_state = G_ON;
                else
                    next_state = G_OFF;
            end
            G_ON: begin
                if (!resetn)
                    next_state = A;
                else
                    next_state = G_ON;
            end
            G_OFF: begin
                if (!resetn)
                    next_state = A;
                else
                    next_state = G_OFF;
            end
            default: next_state = A;
        endcase
    end

    // Output logic (Moore): outputs depend only on current state
    assign f = (state == F_PULSE);
    assign g = (state == G_PULSE) || (state == MONITOR_Y_0) || (state == MONITOR_Y_1) || (state == G_ON);

endmodule