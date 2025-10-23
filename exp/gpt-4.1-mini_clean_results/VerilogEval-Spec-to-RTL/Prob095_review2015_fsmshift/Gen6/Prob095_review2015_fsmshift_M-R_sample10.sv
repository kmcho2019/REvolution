module TopModule (
    input clk,
    input reset,
    output reg shift_ena
);

    // State encoding
    typedef enum logic [0:0] {
        IDLE = 1'b0,
        ASSERT = 1'b1
    } state_t;

    state_t state, next_state;
    reg [2:0] count; // Counts down from 3 to 0

    // Next state and counter logic
    always @(*) begin
        next_state = state;
        case(state)
            IDLE: begin
                if (reset)
                    next_state = ASSERT;
            end
            ASSERT: begin
                if (count == 3'd0)
                    next_state = IDLE;
            end
        endcase
    end

    // Sequential logic: state, count, and shift_ena update
    always @(posedge clk) begin
        if (reset) begin
            state <= ASSERT;
            count <= 3'd3;
            shift_ena <= 1'b1;
        end else begin
            state <= next_state;
            case(state)
                IDLE: begin
                    shift_ena <= 1'b0;
                    count <= 3'd0; // Hold count at 0 in IDLE
                end
                ASSERT: begin
                    shift_ena <= 1'b1;
                    if (count != 3'd0)
                        count <= count - 1;
                    else
                        count <= 3'd0; // Hold at zero until next reset
                end
            endcase
        end
    end

endmodule