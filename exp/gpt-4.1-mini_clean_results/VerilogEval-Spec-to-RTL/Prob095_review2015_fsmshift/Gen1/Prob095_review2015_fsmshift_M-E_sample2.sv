module TopModule (
    input clk,
    input reset,
    output reg shift_ena
);

    // States definition
    typedef enum reg [1:0] {
        IDLE = 2'd0,
        ENABLE = 2'd1,
        DONE = 2'd2
    } state_t;

    state_t state, next_state;
    reg [1:0] enable_count; // 2 bits to count 4 cycles (0 to 3)

    // No pattern_detected input; for future extension, define internal signal as 0
    wire pattern_detected = 1'b0;

    // State transition logic (synchronous reset, positive clock edge)
    always @(posedge clk) begin
        if (reset) begin
            state <= ENABLE;        // On reset, assert shift_ena for 4 cycles
            enable_count <= 2'd0;  // Start counting cycles from 0
        end else begin
            state <= next_state;
            // Increment enable_count only in ENABLE state
            if (state == ENABLE) begin
                enable_count <= enable_count + 1'b1;
            end else begin
                enable_count <= 2'd0; // Clear count outside ENABLE
            end
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (pattern_detected)
                    next_state = ENABLE;
                else
                    next_state = IDLE;
            end
            ENABLE: begin
                if (enable_count == 2'd3)
                    next_state = DONE;
                else
                    next_state = ENABLE;
            end
            DONE: begin
                if (pattern_detected)
                    next_state = ENABLE;
                else
                    next_state = DONE;
            end
            default: next_state = IDLE;
        endcase
    end

    // Output logic
    always @(*) begin
        case (state)
            ENABLE: shift_ena = 1'b1;
            default: shift_ena = 1'b0;
        endcase
    end

endmodule