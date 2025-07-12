module TopModule (
    input  wire clk,
    input  wire reset,          // synchronous active-high reset
    input  wire pattern_detected, // input to trigger shift enable for 4 cycles
    output wire shift_ena
);

    // FSM state declaration
    typedef enum logic [1:0] {
        IDLE  = 2'd0,
        SHIFT = 2'd1
    } state_t;

    state_t state, next_state;

    reg [2:0] count;  // counter for shift_ena duration

    // Next state logic and counter update
    always @(posedge clk) begin
        if (reset) begin
            state <= SHIFT;
            count <= 3'd4;
        end else begin
            state <= next_state;
            if (state == SHIFT) begin
                if (count != 0)
                    count <= count - 1;
            end else if (next_state == SHIFT) begin
                // Reload counter when entering SHIFT state
                count <= 3'd4;
            end
        end
    end

    // Combinational next state logic
    always @(*) begin
        case(state)
            IDLE: 
                if (pattern_detected)
                    next_state = SHIFT;
                else
                    next_state = IDLE;
            SHIFT:
                if (count == 1)
                    next_state = IDLE;
                else
                    next_state = SHIFT;
            default:
                next_state = IDLE;
        endcase
    end

    // Output asserted only in SHIFT state
    assign shift_ena = (state == SHIFT);

endmodule