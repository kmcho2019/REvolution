module TopModule(
    input  wire clk,
    input  wire resetn,  // synchronous active low reset
    input  wire x,
    input  wire y,
    output wire f,
    output wire g
);

    // Define states as one-hot encoding (for clarity and simplicity)
    localparam A           = 8'b0000_0001; // reset state
    localparam F_PULSE     = 8'b0000_0010; // f=1 for one cycle after resetn deassert
    localparam WAIT_PATTERN= 8'b0000_0100; // monitor x input for pattern 101
    localparam G_PULSE     = 8'b0000_1000; // g=1 one cycle after pattern found
    localparam MONITOR_Y_0 = 8'b0001_0000; // monitor y cycle 0 (g=1)
    localparam MONITOR_Y_1 = 8'b0010_0000; // monitor y cycle 1 (g=1)
    localparam G_ON        = 8'b0100_0000; // g=1 permanent
    localparam G_OFF       = 8'b1000_0000; // g=0 permanent

    reg [7:0] state, next_state;

    // Shift register for x input samples, 3 bits
    reg [2:0] x_shift;
    // Counter to track how many samples of x have been received
    reg [1:0] x_sample_count;

    // Sequential logic for state and x_shift updating
    always @(posedge clk) begin
        if (!resetn) begin
            state          <= A;
            x_shift        <= 3'b000;
            x_sample_count <= 2'd0;
        end else begin
            state <= next_state;

            // Update x_shift and sample count only in WAIT_PATTERN state
            if (next_state == WAIT_PATTERN) begin
                x_shift <= {x_shift[1:0], x};
                if (x_sample_count < 3)
                    x_sample_count <= x_sample_count + 1'b1;
                // else hold at 3
            end else begin
                // In any other state, reset sample count and shift register
                x_shift        <= 3'b000;
                x_sample_count <= 2'd0;
            end
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case (state)
            A: begin
                if (resetn)
                    next_state = F_PULSE;
                else
                    next_state = A;
            end
            F_PULSE: begin
                // one cycle f=1, then start monitoring x for pattern
                next_state = WAIT_PATTERN;
            end
            WAIT_PATTERN: begin
                // check pattern only if we have at least 3 samples
                if (x_sample_count >= 3 && x_shift == 3'b101)
                    next_state = G_PULSE;
                else
                    next_state = WAIT_PATTERN;
            end
            G_PULSE: begin
                // one cycle g=1 pulse, then start monitoring y for 2 cycles
                next_state = MONITOR_Y_0;
            end
            MONITOR_Y_0: begin
                if (y == 1'b1)
                    next_state = G_ON;    // y=1 detected first cycle
                else
                    next_state = MONITOR_Y_1; // check one more cycle
            end
            MONITOR_Y_1: begin
                if (y == 1'b1)
                    next_state = G_ON;    // y=1 detected second cycle
                else
                    next_state = G_OFF;   // no y=1 in 2 cycles
            end
            G_ON: begin
                // permanent g=1 until reset
                if (!resetn)
                    next_state = A;
                else
                    next_state = G_ON;
            end
            G_OFF: begin
                // permanent g=0 until reset
                if (!resetn)
                    next_state = A;
                else
                    next_state = G_OFF;
            end
            default: begin
                next_state = A; // default to reset state
            end
        endcase
    end

    // Output logic (Moore outputs)
    assign f = (state == F_PULSE);
    assign g = (state == G_PULSE) || (state == MONITOR_Y_0) || (state == MONITOR_Y_1) || (state == G_ON);

endmodule