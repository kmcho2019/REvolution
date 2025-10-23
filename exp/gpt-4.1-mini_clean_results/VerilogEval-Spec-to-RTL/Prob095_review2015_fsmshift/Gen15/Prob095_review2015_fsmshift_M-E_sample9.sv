module TopModule (
    input  wire clk,
    input  wire reset,           // synchronous active-high reset
    input  wire pattern_detected, // input signal that triggers enabling shift_ena
    output reg  shift_ena
);

    typedef enum logic [0:0] {
        IDLE  = 1'b0,
        SHIFT = 1'b1
    } state_t;

    state_t state, next_state;
    reg [2:0] count, next_count; // 3 bits to count from 4 down to 0

    // State and counter sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= SHIFT;
            count <= 3'd4;
        end else begin
            state <= next_state;
            count <= next_count;
        end
    end

    // Next state logic and counter updates
    always @* begin
        next_state = state;
        next_count = count;
        shift_ena = 1'b0;

        case(state)
            IDLE: begin
                shift_ena = 1'b0;
                if (pattern_detected) begin
                    next_state = SHIFT;
                    next_count = 3'd4;
                end
            end
            SHIFT: begin
                shift_ena = 1'b1;
                if (count != 0) begin
                    next_count = count - 1;
                    next_state = SHIFT;
                end else begin
                    next_state = IDLE;
                end
            end
        endcase
    end

endmodule