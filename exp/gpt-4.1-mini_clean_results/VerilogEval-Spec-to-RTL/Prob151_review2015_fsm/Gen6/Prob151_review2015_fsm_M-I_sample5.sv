module TopModule(
    input  wire clk,
    input  wire reset,
    input  wire data,
    input  wire done_counting,
    input  wire ack,
    output wire shift_ena,
    output wire counting,
    output wire done
);

    // FSM state encoding
    typedef enum logic [1:0] {
        IDLE       = 2'd0,
        SHIFT      = 2'd1,
        WAIT_COUNT = 2'd2,
        WAIT_ACK   = 2'd3
    } state_t;

    state_t state, next_state;

    // 4-bit shift register to detect pattern "1101"
    reg [3:0] pattern_reg;
    reg pattern_detected;

    // Counter for 4 shift cycles
    reg [1:0] shift_cnt;

    // Update pattern register every clock cycle synchronously
    always @(posedge clk) begin
        if (reset) begin
            pattern_reg <= 4'b0000;
        end else begin
            pattern_reg <= {pattern_reg[2:0], data};
        end
    end

    // Register pattern detection to synchronize to FSM clock domain
    always @(posedge clk) begin
        if (reset) begin
            pattern_detected <= 1'b0;
        end else begin
            // Detect pattern 1101 in pattern_reg
            pattern_detected <= (pattern_reg == 4'b1101);
        end
    end

    // FSM next state logic
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (pattern_detected)
                    next_state = SHIFT;
            end
            SHIFT: begin
                if (shift_cnt == 2'd3)
                    next_state = WAIT_COUNT;
            end
            WAIT_COUNT: begin
                if (done_counting)
                    next_state = WAIT_ACK;
            end
            WAIT_ACK: begin
                if (ack)
                    next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

    // FSM state register and shift counter
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_cnt <= 2'd0;
        end else begin
            state <= next_state;
            // Shift counter counts only in SHIFT state
            if (state == SHIFT) begin
                shift_cnt <= shift_cnt + 1'b1;
            end else begin
                shift_cnt <= 2'd0;
            end
        end
    end

    // Outputs (Moore style)
    assign shift_ena = (state == SHIFT);
    assign counting  = (state == WAIT_COUNT);
    assign done      = (state == WAIT_ACK);

endmodule