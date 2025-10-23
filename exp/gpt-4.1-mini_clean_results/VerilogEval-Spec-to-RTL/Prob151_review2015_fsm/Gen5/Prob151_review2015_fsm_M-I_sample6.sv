module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire data,
    input  wire done_counting,
    input  wire ack,
    output reg  shift_ena,
    output reg  counting,
    output reg  done
);

    // 4-bit shift register for pattern detection
    reg [3:0] pattern_shift;
    wire pattern_match = (pattern_shift == 4'b1101);

    // Flag to latch pattern detection once per pattern event
    reg start_pattern_detected;

    // FSM one-hot encoding
    localparam IDLE  = 4'b0001,
               SHIFT = 4'b0010,
               COUNT = 4'b0100,
               DONE  = 4'b1000;

    reg [3:0] state, next_state;

    // 2-bit counter for SHIFT cycles (0 to 3)
    reg [1:0] shift_count;

    // Pattern detection and start_pattern_detected flag logic
    always @(posedge clk) begin
        if (reset) begin
            pattern_shift         <= 4'b0000;
            start_pattern_detected <= 1'b0;
        end else begin
            // Shift in new data bit
            pattern_shift <= {pattern_shift[2:0], data};
            // Latch pattern_detected only if not already latched
            if (pattern_match && !start_pattern_detected && (state == IDLE)) begin
                start_pattern_detected <= 1'b1;
            end
            // Clear start_pattern_detected when entering SHIFT state (to allow new detections)
            if (next_state == SHIFT) begin
                start_pattern_detected <= 1'b0;
            end
        end
    end

    // FSM state register
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_count <= 2'd0;
        end else begin
            state <= next_state;
            // Shift count logic: increment in SHIFT state, else reset
            if (state == SHIFT) begin
                shift_count <= shift_count + 2'd1;
            end else begin
                shift_count <= 2'd0;
            end
        end
    end

    // FSM next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (start_pattern_detected)       next_state = SHIFT;
                else                             next_state = IDLE;
            end
            SHIFT: begin
                if (shift_count == 2'd3)          next_state = COUNT;
                else                             next_state = SHIFT;
            end
            COUNT: begin
                if (done_counting)                next_state = DONE;
                else                             next_state = COUNT;
            end
            DONE: begin
                if (ack)                         next_state = IDLE;
                else                             next_state = DONE;
            end
            default: next_state = IDLE;
        endcase
    end

    // Outputs registered synchronously with state
    always @(posedge clk) begin
        if (reset) begin
            shift_ena <= 1'b0;
            counting  <= 1'b0;
            done      <= 1'b0;
        end else begin
            shift_ena <= (state == SHIFT);
            counting  <= (state == COUNT);
            done      <= (state == DONE);
        end
    end

endmodule