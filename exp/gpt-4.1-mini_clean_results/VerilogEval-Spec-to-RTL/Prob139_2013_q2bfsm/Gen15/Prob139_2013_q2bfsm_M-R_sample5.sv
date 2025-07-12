module TopModule (
    input  wire clk,
    input  wire resetn,  // synchronous active low reset
    input  wire x,
    input  wire y,
    output wire f,
    output wire g
);

    // States encoding
    typedef enum logic [2:0] {
        ST_A = 3'd0,        // Reset state, waiting for resetn release
        ST_F_PULSE = 3'd1,  // Assert f=1 for one cycle
        ST_WAIT_101 = 3'd2, // Waiting for x pattern 1 0 1
        ST_G_PULSE = 3'd3,  // Assert g=1 for one cycle after pattern
        ST_Y_MONITOR = 3'd4,// Monitor y for up to 2 cycles
        ST_G_ON = 3'd5,     // g=1 permanent
        ST_G_OFF = 3'd6     // g=0 permanent
    } state_t;

    state_t state, next_state;

    // Shift register for x input history (3 bits)
    reg [2:0] x_shift;

    // Counter for y monitoring (0 to 2 cycles)
    reg [1:0] y_count;

    // Sequential logic: synchronous reset, update state, x_shift and y_count
    always @(posedge clk) begin
        if (!resetn) begin
            state <= ST_A;
            x_shift <= 3'b000;
            y_count <= 2'd0;
        end else begin
            state <= next_state;
            x_shift <= {x_shift[1:0], x};
            // y_count update depends on state in next_state logic
            if (state == ST_Y_MONITOR) begin
                if (y == 1'b1)
                    y_count <= 2'd0;
                else if (y_count < 2'd2)
                    y_count <= y_count + 1'b1;
                else
                    y_count <= y_count; // stay at max count
            end else begin
                y_count <= 2'd0;
            end
        end
    end

    // Combinational next-state logic
    always @(*) begin
        next_state = state; // default hold
        case (state)
            ST_A: begin
                // Hold here as long as resetn == 0
                if (resetn)
                    next_state = ST_F_PULSE; // move on after resetn released
            end
            ST_F_PULSE: begin
                // After one cycle asserting f=1, move to wait for x pattern
                next_state = ST_WAIT_101;
            end
            ST_WAIT_101: begin
                // Wait until x_shift matches pattern 1 0 1
                if (x_shift == 3'b101)
                    next_state = ST_G_PULSE;
            end
            ST_G_PULSE: begin
                // One cycle g=1 pulse after detecting pattern, then monitor y
                next_state = ST_Y_MONITOR;
            end
            ST_Y_MONITOR: begin
                // Monitor y for up to 2 clock cycles (counts 0,1,2)
                if (y == 1'b1)
                    next_state = ST_G_ON;  // hold g=1 permanently
                else if (y_count == 2'd2)
                    next_state = ST_G_OFF; // hold g=0 permanently
                else
                    next_state = ST_Y_MONITOR; // continue monitoring
            end
            ST_G_ON: begin
                // Hold g=1 forever until reset
                next_state = ST_G_ON;
            end
            ST_G_OFF: begin
                // Hold g=0 forever until reset
                next_state = ST_G_OFF;
            end
            default: begin
                next_state = ST_A;
            end
        endcase
    end

    // Outputs as Mealy outputs depending on state and/or inputs if needed
    // f = 1 for one cycle only in ST_F_PULSE
    // g = 1 only in ST_G_PULSE (one cycle pulse), and held in ST_G_ON; zero elsewhere
    assign f = (state == ST_F_PULSE);
    assign g = (state == ST_G_PULSE) || (state == ST_G_ON);

endmodule