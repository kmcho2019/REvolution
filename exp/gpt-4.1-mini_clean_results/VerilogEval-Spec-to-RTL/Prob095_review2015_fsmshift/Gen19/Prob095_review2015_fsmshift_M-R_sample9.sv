module TopModule (
    input  wire clk,
    input  wire reset,      // synchronous active-high reset
    output reg  shift_ena
);

    // FSM states
    typedef enum logic [0:0] {
        IDLE         = 1'b0,
        SHIFT_ACTIVE = 1'b1
    } state_t;

    reg [1:0] cycle_count; // counts 0..3 for 4 cycles
    state_t current_state, next_state;

    // State transition and counter update
    always @(posedge clk) begin
        if (reset) begin
            current_state <= SHIFT_ACTIVE;
            cycle_count   <= 2'd0;
        end else begin
            current_state <= next_state;
            if (current_state == SHIFT_ACTIVE) begin
                cycle_count <= cycle_count + 1'b1;
            end else begin
                cycle_count <= 2'd0;
            end
        end
    end

    // Next state logic
    always @(*) begin
        case (current_state)
            IDLE: begin
                // Stay IDLE unless reset asserted (handled synchronously above)
                next_state = IDLE;
            end

            SHIFT_ACTIVE: begin
                // After 4 cycles (count 0..3), go to IDLE
                if (cycle_count == 2'd3)
                    next_state = IDLE;
                else
                    next_state = SHIFT_ACTIVE;
            end

            default: next_state = IDLE;
        endcase
    end

    // Output logic
    always @(*) begin
        case (current_state)
            SHIFT_ACTIVE: shift_ena = 1'b1;
            default:      shift_ena = 1'b0;
        endcase
    end

endmodule