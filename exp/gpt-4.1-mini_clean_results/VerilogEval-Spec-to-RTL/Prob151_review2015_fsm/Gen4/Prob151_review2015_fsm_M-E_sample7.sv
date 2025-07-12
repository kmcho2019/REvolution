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

    // FSM states
    typedef enum logic [1:0] {
        IDLE       = 2'd0,
        LOAD       = 2'd1,
        WAIT_COUNT = 2'd2,
        SIGNAL_DONE= 2'd3
    } state_t;

    state_t state, next_state;

    // 4-bit shift register for pattern detection
    reg [3:0] pattern_shift;

    // Shift counter for counting exactly 4 shift cycles
    reg [1:0] shift_counter;

    // Pattern match flag (1101)
    wire pattern_matched = (pattern_shift == 4'b1101);

    // Shift pattern register every clock
    always @(posedge clk) begin
        if (reset) begin
            pattern_shift <= 4'b0000;
        end else begin
            pattern_shift <= {pattern_shift[2:0], data};
        end
    end

    // FSM state register and shift counter synchronous update
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_counter <= 2'd0;
        end else begin
            state <= next_state;

            if (state == LOAD) begin
                shift_counter <= shift_counter + 2'd1;
            end else begin
                shift_counter <= 2'd0;
            end
        end
    end

    // Next state logic combinational
    always @(*) begin
        next_state = state; // default hold
        case (state)
            IDLE: begin
                if (pattern_matched)
                    next_state = LOAD;
            end
            LOAD: begin
                if (shift_counter == 2'd3) // after 4 cycles (0..3)
                    next_state = WAIT_COUNT;
            end
            WAIT_COUNT: begin
                if (done_counting)
                    next_state = SIGNAL_DONE;
            end
            SIGNAL_DONE: begin
                if (ack)
                    next_state = IDLE;
            end
        endcase
    end

    // Outputs synchronous registered
    always @(posedge clk) begin
        if (reset) begin
            shift_ena <= 1'b0;
            counting  <= 1'b0;
            done      <= 1'b0;
        end else begin
            shift_ena <= (state == LOAD);
            counting  <= (state == WAIT_COUNT);
            done      <= (state == SIGNAL_DONE);
        end
    end

endmodule