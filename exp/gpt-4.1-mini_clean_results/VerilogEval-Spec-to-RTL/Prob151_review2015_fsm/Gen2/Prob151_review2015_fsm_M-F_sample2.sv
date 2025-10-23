module TopModule (
    input        clk,
    input        reset,
    input        data,
    input        done_counting,
    input        ack,
    output reg   shift_ena,
    output reg   counting,
    output reg   done
);
    // FSM states
    typedef enum logic [1:0] {
        SEARCH = 2'b00,
        SHIFT  = 2'b01,
        COUNT  = 2'b10,
        DONE   = 2'b11
    } state_t;

    state_t state, next_state;

    reg [3:0] shift_reg;    // For pattern detection
    reg [2:0] shift_cnt;    // Counts shift cycles in SHIFT state (0 to 3)

    // Sequential logic: state, shift_reg, shift_cnt, outputs
    always @(posedge clk) begin
        if (reset) begin
            state     <= SEARCH;
            shift_reg <= 4'b0000;
            shift_cnt <= 3'd0;
            shift_ena <= 1'b0;
            counting  <= 1'b0;
            done      <= 1'b0;
        end else begin
            state <= next_state;

            // Shift register updates only in SEARCH state for pattern detection
            if (state == SEARCH) begin
                shift_reg <= {shift_reg[2:0], data};
            end
            // Freeze shift_reg otherwise (no update)

            // shift_cnt increments only in SHIFT state, resets otherwise
            if (state == SHIFT) begin
                shift_cnt <= shift_cnt + 3'd1;
            end else begin
                shift_cnt <= 3'd0;
            end

            // Outputs registered, updated based on next_state (which reflects next state)
            // to ensure outputs change aligned with FSM state transitions
            // We'll update outputs based on next_state because state changes next cycle
            case (next_state)
                SEARCH: begin
                    shift_ena <= 1'b0;
                    counting  <= 1'b0;
                    done      <= 1'b0;
                end
                SHIFT: begin
                    shift_ena <= 1'b1;
                    counting  <= 1'b0;
                    done      <= 1'b0;
                end
                COUNT: begin
                    shift_ena <= 1'b0;
                    counting  <= 1'b1;
                    done      <= 1'b0;
                end
                DONE: begin
                    shift_ena <= 1'b0;
                    counting  <= 1'b0;
                    done      <= 1'b1;
                end
                default: begin
                    shift_ena <= 1'b0;
                    counting  <= 1'b0;
                    done      <= 1'b0;
                end
            endcase
        end
    end

    // Combinational logic for next_state
    always @(*) begin
        next_state = state;

        case (state)
            SEARCH: begin
                // Detect pattern 1101 to start SHIFT
                if (shift_reg == 4'b1101)
                    next_state = SHIFT;
            end
            SHIFT: begin
                // After 4 cycles (shift_cnt 0..3), go to COUNT
                if (shift_cnt == 3'd3)
                    next_state = COUNT;
            end
            COUNT: begin
                if (done_counting)
                    next_state = DONE;
            end
            DONE: begin
                if (ack)
                    next_state = SEARCH;
            end
        endcase
    end

endmodule