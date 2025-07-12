module TopModule(
    input  clk,
    input  reset,
    input  data,
    input  done_counting,
    input  ack,
    output reg shift_ena,
    output reg counting,
    output reg done
);

    // Define states
    typedef enum logic [2:0] {
        IDLE     = 3'd0,
        SHIFT_0  = 3'd1,
        SHIFT_1  = 3'd2,
        SHIFT_2  = 3'd3,
        SHIFT_3  = 3'd4,
        COUNTING = 3'd5,
        DONE     = 3'd6
    } state_t;

    state_t state, next_state;

    reg [3:0] shift_reg;        // shift register to detect pattern

    localparam [3:0] PATTERN = 4'b1101;

    // Sequential logic: state and shift_reg update
    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            shift_reg <= 4'b0000;
        end else begin
            state <= next_state;
            // Shift in data every cycle for pattern detection
            shift_reg <= {shift_reg[2:0], data};
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (shift_reg == PATTERN)
                    next_state = SHIFT_0;
            end
            SHIFT_0: next_state = SHIFT_1;
            SHIFT_1: next_state = SHIFT_2;
            SHIFT_2: next_state = SHIFT_3;
            SHIFT_3: next_state = COUNTING;
            COUNTING: if (done_counting) next_state = DONE;
            DONE: if (ack) next_state = IDLE;
        endcase
    end

    // Output logic driven by current state
    always @(posedge clk) begin
        if (reset) begin
            shift_ena <= 1'b0;
            counting  <= 1'b0;
            done      <= 1'b0;
        end else begin
            case(state)
                SHIFT_0,
                SHIFT_1,
                SHIFT_2,
                SHIFT_3: begin
                    shift_ena <= 1'b1;
                    counting  <= 1'b0;
                    done      <= 1'b0;
                end
                COUNTING: begin
                    shift_ena <= 1'b0;
                    counting  <= 1'b1;
                    done      <= 1'b0;
                end
                DONE: begin
                    shift_ena <= 1'b0;
                    counting  <= 1'b0;
                    done      <= 1'b1;
                end
                default: begin // IDLE and any others
                    shift_ena <= 1'b0;
                    counting  <= 1'b0;
                    done      <= 1'b0;
                end
            endcase
        end
    end

endmodule