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
    typedef enum logic [2:0] {
        SEARCH0 = 3'd0,
        SEARCH1 = 3'd1,
        SEARCH2 = 3'd2,
        SEARCH3 = 3'd3,
        SHIFT   = 3'd4,
        COUNT   = 3'd5,
        DONE    = 3'd6
    } state_t;

    state_t state, next_state;
    reg [1:0] shift_count, next_shift_count;

    // Sequential logic: state and shift_count update
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH0;
            shift_count <= 2'd0;
            shift_ena <= 1'b0;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            shift_count <= next_shift_count;
            // Update outputs as registered signals for Moore FSM
            case (next_state)
                SHIFT: begin
                    shift_ena <= 1'b1;
                    counting <= 1'b0;
                    done <= 1'b0;
                end
                COUNT: begin
                    shift_ena <= 1'b0;
                    counting <= 1'b1;
                    done <= 1'b0;
                end
                DONE: begin
                    shift_ena <= 1'b0;
                    counting <= 1'b0;
                    done <= 1'b1;
                end
                default: begin
                    shift_ena <= 1'b0;
                    counting <= 1'b0;
                    done <= 1'b0;
                end
            endcase
        end
    end

    // Combinational logic: determine next_state and next_shift_count
    always @(*) begin
        next_state = state;
        next_shift_count = shift_count;

        case (state)
            SEARCH0: next_state = (data) ? SEARCH1 : SEARCH0;
            SEARCH1: next_state = (data) ? SEARCH2 : SEARCH0;
            SEARCH2: next_state = (~data) ? SEARCH3 : SEARCH2;
            SEARCH3: next_state = (data) ? SHIFT : SEARCH0;
            SHIFT: begin
                if (shift_count == 2'd3)
                    next_state = COUNT;
                else
                    next_state = SHIFT;
                next_shift_count = shift_count + 2'd1;
            end
            COUNT: next_state = done_counting ? DONE : COUNT;
            DONE:  next_state = ack ? SEARCH0 : DONE;
            default: next_state = SEARCH0;
        endcase
    end

endmodule