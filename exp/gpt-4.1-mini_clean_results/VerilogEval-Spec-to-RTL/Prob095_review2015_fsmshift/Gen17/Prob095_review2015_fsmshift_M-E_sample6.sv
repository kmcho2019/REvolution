module TopModule (
    input  wire clk,
    input  wire reset,             // synchronous active-high reset
    input  wire pattern_detected, // input indicating the proper bit pattern detected
    output reg  shift_ena
);

    typedef enum reg [1:0] {
        IDLE   = 2'b00,
        ENABLE = 2'b01,
        DONE   = 2'b10
    } state_t;

    state_t state, next_state;
    reg [1:0] cycle_cnt; // counts from 0 to 3 for 4 cycles

    // Next-state logic
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (reset)
                    next_state = ENABLE;
                else if (pattern_detected)
                    next_state = ENABLE;
                else
                    next_state = IDLE;
            end
            ENABLE: begin
                if (cycle_cnt == 2'd3)
                    next_state = DONE;
                else
                    next_state = ENABLE;
            end
            DONE: begin
                if (pattern_detected)
                    next_state = ENABLE;
                else if (reset)
                    next_state = ENABLE;
                else
                    next_state = DONE;
            end
            default: next_state = IDLE;
        endcase
    end

    // Sequential logic: state transition and counters
    always @(posedge clk) begin
        if (reset) begin
            state <= ENABLE;
            cycle_cnt <= 2'd0;
            shift_ena <= 1'b1;
        end else begin
            state <= next_state;
            case (next_state)
                ENABLE: begin
                    if (state == ENABLE)
                        cycle_cnt <= cycle_cnt + 1'b1;
                    else
                        cycle_cnt <= 2'd0; // reset counter on entering ENABLE
                    shift_ena <= 1'b1;
                end
                default: begin
                    cycle_cnt <= 2'd0;
                    shift_ena <= 1'b0;
                end
            endcase
        end
    end

endmodule