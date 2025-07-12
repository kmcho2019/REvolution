module TopModule (
    input  clk,
    input  reset,
    input  data,
    input  done_counting,
    input  ack,
    output reg shift_ena,
    output reg counting,
    output reg done
);

    // FSM states
    typedef enum logic [1:0] {
        IDLE = 2'd0,
        SHIFT = 2'd1,
        COUNTING = 2'd2,
        DONE = 2'd3
    } state_t;

    state_t state, next_state;

    reg [3:0] pattern_reg;   // For pattern detection: last 4 bits shifted in
    reg [2:0] shift_count;   // Counts shift_ena cycles (0 to 3)

    // Pattern detection and state transition
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_reg <= 4'b0000;
            shift_count <= 3'd0;
            shift_ena <= 1'b0;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            // Always shift in data for pattern detection
            pattern_reg <= {pattern_reg[2:0], data};

            state <= next_state;

            case(state)
                IDLE: begin
                    shift_ena <= 1'b0;
                    counting <= 1'b0;
                    done <= 1'b0;
                    shift_count <= 3'd0;
                end
                SHIFT: begin
                    shift_ena <= 1'b1;
                    counting <= 1'b0;
                    done <= 1'b0;
                    shift_count <= shift_count + 1'b1;
                end
                COUNTING: begin
                    shift_ena <= 1'b0;
                    counting <= 1'b1;
                    done <= 1'b0;
                    shift_count <= 3'd0;
                end
                DONE: begin
                    shift_ena <= 1'b0;
                    counting <= 1'b0;
                    done <= 1'b1;
                    shift_count <= 3'd0;
                end
            endcase
        end
    end

    // Next state combinational logic
    always @(*) begin
        next_state = state;
        case(state)
            IDLE: begin
                if (pattern_reg == 4'b1101)
                    next_state = SHIFT;
            end
            SHIFT: begin
                if (shift_count == 3'd3) // After 4 cycles (0 to 3)
                    next_state = COUNTING;
            end
            COUNTING: begin
                if (done_counting)
                    next_state = DONE;
            end
            DONE: begin
                if (ack)
                    next_state = IDLE;
            end
        endcase
    end

endmodule