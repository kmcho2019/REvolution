module TopModule (
    input  wire clk,
    input  wire resetn,  // synchronous active low reset
    input  wire x,
    input  wire y,
    output reg  f,
    output reg  g
);

    // State encoding as localparams for clarity
    localparam [2:0]
        ST_A         = 3'd0, // Reset state, hold while reset asserted
        ST_F_PULSE   = 3'd1, // Assert f=1 one cycle after resetn de-asserted
        ST_WAIT_101  = 3'd2, // Wait for x pattern 1 0 1
        ST_G_PULSE   = 3'd3, // Assert g=1 for one clock cycle
        ST_Y_MONITOR = 3'd4, // Monitor y for up to two cycles
        ST_G_ON      = 3'd5, // g=1 permanently
        ST_G_OFF     = 3'd6; // g=0 permanently

    reg [2:0] state, next_state;

    // Shift register for x input history
    reg [2:0] x_shift;

    // Counter for number of cycles waiting for y
    reg [1:0] y_count;

    // Sequential logic: synchronous reset, state update, x_shift and y_count update
    always @(posedge clk) begin
        if (!resetn) begin
            state   <= ST_A;
            x_shift <= 3'b000;
            y_count <= 2'd0;
            f       <= 1'b0;
            g       <= 1'b0;
        end else begin
            state <= next_state;

            // Update x_shift on every clock cycle (shift left, insert new x)
            x_shift <= {x_shift[1:0], x};

            // Manage y_count only in Y_MONITOR state
            if (state == ST_Y_MONITOR) begin
                if (y == 1'b1) begin
                    y_count <= 2'd0; // reset counter when y=1 observed
                end else if (y_count < 2'd2) begin
                    y_count <= y_count + 1'b1;
                end else begin
                    y_count <= y_count; // hold max count at 2
                end
            end else begin
                y_count <= 2'd0; // reset counter in other states
            end

            // Output logic (Moore): output only depends on current state
            case (next_state)
                ST_F_PULSE: f <= 1'b1;
                default:    f <= 1'b0;
            endcase

            case (next_state)
                ST_G_PULSE, ST_G_ON: g <= 1'b1;
                default:              g <= 1'b0;
            endcase
        end
    end

    // Combinational next state logic
    always @(*) begin
        next_state = state; // default hold

        case (state)
            ST_A: begin
                // Hold here while resetn is low, move on after resetn is released
                if (resetn)
                    next_state = ST_F_PULSE;
            end

            ST_F_PULSE: begin
                // After asserting f=1 for one cycle, go wait for pattern
                next_state = ST_WAIT_101;
            end

            ST_WAIT_101: begin
                // Look for pattern x_shift == 3'b101
                if (x_shift == 3'b101)
                    next_state = ST_G_PULSE;
            end

            ST_G_PULSE: begin
                // One cycle g=1 pulse, then move to y monitor
                next_state = ST_Y_MONITOR;
            end

            ST_Y_MONITOR: begin
                // Monitor y input up to 2 cycles
                if (y == 1'b1)
                    next_state = ST_G_ON;  // Hold g=1 permanently
                else if (y_count == 2'd2)
                    next_state = ST_G_OFF; // Hold g=0 permanently
                else
                    next_state = ST_Y_MONITOR; // Continue monitoring
            end

            ST_G_ON: begin
                // Stay here until reset
                next_state = ST_G_ON;
            end

            ST_G_OFF: begin
                // Stay here until reset
                next_state = ST_G_OFF;
            end

            default: begin
                next_state = ST_A;
            end
        endcase
    end

endmodule