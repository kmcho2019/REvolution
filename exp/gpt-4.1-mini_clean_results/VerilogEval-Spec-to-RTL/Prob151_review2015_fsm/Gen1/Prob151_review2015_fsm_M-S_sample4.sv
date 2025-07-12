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

    // State encoding
    typedef enum logic [1:0] {
        IDLE  = 2'd0,
        SHIFT = 2'd1,
        COUNT = 2'd2,
        DONE  = 2'd3
    } state_t;

    state_t state, next_state;

    reg [3:0] shift_reg;      // to detect pattern 1101
    reg [2:0] shift_count;    // counts 4 cycles during SHIFT state

    wire pattern_detected = (shift_reg == 4'b1101);

    // State and shift register update
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 4'd0;
            shift_count <= 3'd0;
        end else begin
            state <= next_state;

            case (state)
                IDLE: begin
                    // shift in data every clock in IDLE
                    shift_reg <= {shift_reg[2:0], data};
                    shift_count <= 3'd0;
                end
                SHIFT: begin
                    // continue shifting in duration bits during SHIFT
                    shift_reg <= {shift_reg[2:0], data};
                    if (shift_count < 3'd4)
                        shift_count <= shift_count + 1'b1;
                end
                default: begin
                    // hold registers in other states
                    shift_reg <= shift_reg;
                    shift_count <= 3'd0;
                end
            endcase
        end
    end

    // Next state and output logic
    always @(*) begin
        // defaults
        shift_ena = 1'b0;
        counting  = 1'b0;
        done      = 1'b0;
        next_state = state;

        case (state)
            IDLE: begin
                if (pattern_detected)
                    next_state = SHIFT;
            end

            SHIFT: begin
                shift_ena = 1'b1;
                if (shift_count == 3'd4)
                    next_state = COUNT;
            end

            COUNT: begin
                counting = 1'b1;
                if (done_counting)
                    next_state = DONE;
            end

            DONE: begin
                done = 1'b1;
                if (ack)
                    next_state = IDLE;
            end
        endcase
    end

endmodule