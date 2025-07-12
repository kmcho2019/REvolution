module TopModule(
    input  clk,
    input  resetn,
    input  x,
    input  y,
    output reg f,
    output reg g
);

    // State encoding (3 bits sufficient):
    localparam IDLE       = 3'd0; // Wait reset asserted
    localparam F_PULSE    = 3'd1; // Assert f=1 one cycle after reset release
    localparam SEQ_DETECT = 3'd2; // Detect 1,0,1 on x using seq_step
    localparam G_MONITOR  = 3'd3; // g=1, monitor y for up to 2 cycles
    localparam G_ON       = 3'd4; // g=1 permanently
    localparam G_OFF      = 3'd5; // g=0 permanently

    reg [2:0] state, next_state;

    // Sequence detector step: 0 to 3
    // 0 = waiting for first '1'
    // 1 = first '1' matched, waiting for '0'
    // 2 = '1','0' matched, waiting for final '1'
    // 3 = full pattern matched (transient)
    reg [1:0] seq_step, next_seq_step;

    // Monitor y cycle counter: counts 0,1 (2 cycles max)
    reg [1:0] y_count, next_y_count;

    // Sequential logic: state and registers update on clock
    always @(posedge clk) begin
        if (!resetn) begin
            state <= IDLE;
            seq_step <= 2'd0;
            y_count <= 2'd0;
            f <= 1'b0;
            g <= 1'b0;
        end else begin
            state <= next_state;
            seq_step <= next_seq_step;
            y_count <= next_y_count;
            f <= (next_state == F_PULSE);
            // g depends on state only, handled below
        end
    end

    // Next state and outputs logic
    always @(*) begin
        // Defaults: hold current values
        next_state = state;
        next_seq_step = seq_step;
        next_y_count = y_count;

        case(state)
            IDLE: begin
                // Wait for reset release
                next_seq_step = 2'd0;
                next_y_count = 2'd0;
                if (resetn)
                    next_state = F_PULSE;
            end

            F_PULSE: begin
                // After asserting f=1 for one cycle, start sequence detection
                next_state = SEQ_DETECT;
                next_seq_step = 2'd0; // start detection at step 0
            end

            SEQ_DETECT: begin
                // Detect pattern 1,0,1 on x in sequence
                case(seq_step)
                    2'd0: // waiting first '1'
                        if (x == 1'b1)
                            next_seq_step = 2'd1;
                        else
                            next_seq_step = 2'd0;
                    2'd1: // matched first '1', wait for '0'
                        if (x == 1'b0)
                            next_seq_step = 2'd2;
                        else if (x == 1'b1)
                            next_seq_step = 2'd1; // stay here for overlapping patterns
                        else
                            next_seq_step = 2'd0;
                    2'd2: // matched '1','0', wait for final '1'
                        if (x == 1'b1)
                            next_seq_step = 2'd3; // pattern complete
                        else if (x == 1'b0)
                            next_seq_step = 2'd0; // restart pattern
                        else
                            next_seq_step = 2'd0;
                    2'd3: begin
                        // pattern matched, move to monitor y
                        next_seq_step = 2'd0;
                        next_state = G_MONITOR;
                        next_y_count = 2'd0;
                    end
                    default: next_seq_step = 2'd0;
                endcase
            end

            G_MONITOR: begin
                // g=1 asserted, monitor y for up to 2 cycles
                if (y == 1'b1) begin
                    next_state = G_ON; // lock g=1 permanently
                end else if (y_count == 2'd1) begin
                    // 2 cycles elapsed with no y=1, lock g=0 permanently
                    next_state = G_OFF;
                end else begin
                    // increment y_count, stay monitoring
                    next_y_count = y_count + 1'b1;
                    next_state = G_MONITOR;
                end
            end

            G_ON: begin
                // Permanently g=1 until reset
                next_state = G_ON;
            end

            G_OFF: begin
                // Permanently g=0 until reset
                next_state = G_OFF;
            end

            default: begin
                // Should not occur, reset to IDLE
                next_state = IDLE;
                next_seq_step = 2'd0;
                next_y_count = 2'd0;
            end
        endcase
    end

    // Output g logic (Moore)
    always @(posedge clk) begin
        if (!resetn) begin
            g <= 1'b0;
        end else begin
            case(state)
                G_MONITOR, G_ON: g <= 1'b1;
                default: g <= 1'b0;
            endcase
        end
    end

endmodule