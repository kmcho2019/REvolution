module TopModule(
    input  wire clk,
    input  wire resetn, // synchronous active low reset
    input  wire x,
    input  wire y,
    output reg  f,
    output reg  g
);

    // FSM states encoding
    typedef enum reg [2:0] {
        IDLE        = 3'd0,  // waiting for reset release
        PULSE_F     = 3'd1,  // output f=1 for one cycle
        WAIT_PATTERN= 3'd2,  // monitor input x for pattern 101
        SET_G       = 3'd3,  // output g=1 for one cycle after pattern detected
        MONITOR_Y_0 = 3'd4,  // g=1, 1st cycle monitoring y
        MONITOR_Y_1 = 3'd5,  // g=1, 2nd cycle monitoring y
        PERM_G_ON   = 3'd6,  // g=1 permanently
        PERM_G_OFF  = 3'd7   // g=0 permanently
    } state_t;

    reg [2:0] state, next_state;

    // 3-bit shift register for pattern detection: newest x at LSB
    reg [2:0] x_shift, next_x_shift;

    // FSM sequential logic
    always @(posedge clk) begin
        if (!resetn) begin
            state    <= IDLE;
            x_shift  <= 3'b000;
            f        <= 1'b0;
            g        <= 1'b0;
        end else begin
            state    <= next_state;
            x_shift  <= next_x_shift;
            // Outputs assigned below based on next_state (Moore)
            // but updated here to hold stable outputs during each state
            case (next_state)
                PULSE_F:    begin f <= 1'b1; g <= 1'b0; end
                WAIT_PATTERN:begin f <= 1'b0; g <= 1'b0; end
                SET_G:      begin f <= 1'b0; g <= 1'b1; end
                MONITOR_Y_0:begin f <= 1'b0; g <= 1'b1; end
                MONITOR_Y_1:begin f <= 1'b0; g <= 1'b1; end
                PERM_G_ON:  begin f <= 1'b0; g <= 1'b1; end
                PERM_G_OFF: begin f <= 1'b0; g <= 1'b0; end
                default:    begin f <= 1'b0; g <= 1'b0; end // IDLE and others
            endcase
        end
    end

    // FSM combinational next state and inputs update
    always @(*) begin
        next_state   = state;
        next_x_shift = {x_shift[1:0], x}; // Shift in newest x bit

        case (state)
            IDLE: begin
                // Wait here while resetn asserted low
                // Once resetn deasserted, go to PULSE_F on next clock
                // Because resetn synchronous, this transition happens on clock edge after resetn=1
                next_state = PULSE_F;
            end

            PULSE_F: begin
                // One cycle f=1 (handled in output logic)
                next_state = WAIT_PATTERN;
                // Clear shift register to start fresh pattern detection
                next_x_shift = 3'b000;
            end

            WAIT_PATTERN: begin
                // Detect pattern 3'b101 on x_shift
                if (next_x_shift == 3'b101) begin
                    next_state = SET_G;
                end else begin
                    next_state = WAIT_PATTERN;
                end
            end

            SET_G: begin
                // One cycle g=1
                next_state = MONITOR_Y_0;
            end

            MONITOR_Y_0: begin
                // First cycle monitoring y, g=1
                if (y == 1'b1) begin
                    next_state = PERM_G_ON;
                end else begin
                    next_state = MONITOR_Y_1;
                end
            end

            MONITOR_Y_1: begin
                // Second cycle monitoring y, g=1
                if (y == 1'b1) begin
                    next_state = PERM_G_ON;
                end else begin
                    next_state = PERM_G_OFF;
                end
            end

            PERM_G_ON: begin
                // Stay here forever until reset
                next_state = PERM_G_ON;
            end

            PERM_G_OFF: begin
                // Stay here forever until reset
                next_state = PERM_G_OFF;
            end

            default: begin
                next_state = IDLE;
                next_x_shift = 3'b000;
            end
        endcase
    end

endmodule