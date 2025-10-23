module TopModule (
    input  wire clk,
    input  wire resetn,  // synchronous active low reset
    input  wire x,
    input  wire y,
    output reg  f,
    output reg  g
);

    // State encoding
    localparam [2:0]
        RESET_STATE        = 3'd0,
        F_PULSE_STATE      = 3'd1,
        PATTERN_WAIT_STATE = 3'd2,
        G_PULSE_STATE      = 3'd3,
        Y_MONITOR_STATE    = 3'd4,
        G_ON_STATE         = 3'd5,
        G_OFF_STATE        = 3'd6;

    reg [2:0] state, next_state;

    // Shift register holding last 3 x samples (MSB oldest)
    reg [2:0] x_shift_reg, next_x_shift_reg;

    // Counter to track number of cycles in Y_MONITOR_STATE (max 2 cycles)
    reg [1:0] y_monitor_cnt, next_y_monitor_cnt;

    // Sequential logic: state, shift register, counter update
    always @(posedge clk) begin
        if (!resetn) begin
            state         <= RESET_STATE;
            x_shift_reg   <= 3'b000;
            y_monitor_cnt <= 2'd0;
        end else begin
            state         <= next_state;
            x_shift_reg   <= next_x_shift_reg;
            y_monitor_cnt <= next_y_monitor_cnt;
        end
    end

    // Combinational next state, shift register, and counter logic
    always @(*) begin
        // Default assignments: hold values
        next_state       = state;
        next_x_shift_reg = x_shift_reg;
        next_y_monitor_cnt = y_monitor_cnt;

        case (state)
            RESET_STATE: begin
                // Wait here while reset asserted
                if (resetn) begin
                    next_state       = F_PULSE_STATE;
                    next_x_shift_reg = 3'b000;
                    next_y_monitor_cnt = 2'd0;
                end else begin
                    next_state       = RESET_STATE;
                    next_x_shift_reg = 3'b000;
                    next_y_monitor_cnt = 2'd0;
                end
            end

            F_PULSE_STATE: begin
                // One cycle pulse f=1, then start monitoring pattern
                next_state       = PATTERN_WAIT_STATE;
                next_x_shift_reg = {x_shift_reg[1:0], x};
                next_y_monitor_cnt = 2'd0;
            end

            PATTERN_WAIT_STATE: begin
                // Shift in new x
                next_x_shift_reg = {x_shift_reg[1:0], x};

                if ({x_shift_reg[1:0], x} == 3'b101) begin
                    // Pattern detected, pulse g next cycle
                    next_state = G_PULSE_STATE;
                    next_y_monitor_cnt = 2'd0;
                end else begin
                    next_state = PATTERN_WAIT_STATE;
                    next_y_monitor_cnt = 2'd0;
                end
            end

            G_PULSE_STATE: begin
                // g=1 for one cycle, then monitor y for up to 2 cycles
                next_state = Y_MONITOR_STATE;
                next_y_monitor_cnt = 2'd0;
                // Shift reg no change
                next_x_shift_reg = x_shift_reg;
            end

            Y_MONITOR_STATE: begin
                // Keep g=1 while monitoring y within 2 clock cycles
                if (y == 1'b1) begin
                    // y detected, hold g=1 permanently
                    next_state = G_ON_STATE;
                    next_y_monitor_cnt = 2'd0;
                end else if (y_monitor_cnt == 2'd1) begin
                    // After 2 cycles (0 and 1 counted), y not detected, clear g
                    next_state = G_OFF_STATE;
                    next_y_monitor_cnt = 2'd0;
                end else begin
                    // Increment cycle count, continue monitoring
                    next_state = Y_MONITOR_STATE;
                    next_y_monitor_cnt = y_monitor_cnt + 1'b1;
                end
                next_x_shift_reg = x_shift_reg;
            end

            G_ON_STATE: begin
                // Hold g=1 permanently
                next_state = G_ON_STATE;
                next_y_monitor_cnt = 2'd0;
                next_x_shift_reg = x_shift_reg;
            end

            G_OFF_STATE: begin
                // Hold g=0 permanently
                next_state = G_OFF_STATE;
                next_y_monitor_cnt = 2'd0;
                next_x_shift_reg = x_shift_reg;
            end

            default: begin
                next_state       = RESET_STATE;
                next_x_shift_reg = 3'b000;
                next_y_monitor_cnt = 2'd0;
            end
        endcase
    end

    // Output logic: Moore outputs depend on current state
    always @(*) begin
        // Default outputs
        f = 1'b0;
        g = 1'b0;
        case (state)
            F_PULSE_STATE:    f = 1'b1;
            G_PULSE_STATE,
            Y_MONITOR_STATE,
            G_ON_STATE:       g = 1'b1;
            default:          ;
        endcase
    end

endmodule