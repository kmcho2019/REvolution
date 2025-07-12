module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire pattern_detected,  // Input assumed for pattern detection trigger
    output reg  shift_ena
);

    typedef enum logic [1:0] {
        IDLE = 2'd0,
        RUN  = 2'd1,
        DONE = 2'd2
    } state_t;

    state_t state, next_state;
    reg [1:0] cycle_count;  // Counts 0..3 for 4 cycles

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state       <= RUN;
            cycle_count <= 2'd0;
        end else begin
            state <= next_state;
            if (state == RUN) begin
                cycle_count <= cycle_count + 1'b1;
            end else begin
                cycle_count <= 2'd0;
            end
        end
    end

    // Next state logic
    always @(*) begin
        case(state)
            IDLE: begin
                if (pattern_detected)
                    next_state = RUN;
                else
                    next_state = IDLE;
            end
            RUN: begin
                if (cycle_count == 2'd3)
                    next_state = DONE;
                else
                    next_state = RUN;
            end
            DONE: begin
                if (pattern_detected)
                    next_state = RUN;
                else
                    next_state = DONE;
            end
            default: next_state = IDLE;
        endcase
    end

    // Output logic
    always @(posedge clk) begin
        if (reset) begin
            shift_ena <= 1'b1;
        end else begin
            // Assert shift_ena only when in RUN state (for exactly 4 cycles)
            shift_ena <= (state == RUN);
        end
    end

endmodule