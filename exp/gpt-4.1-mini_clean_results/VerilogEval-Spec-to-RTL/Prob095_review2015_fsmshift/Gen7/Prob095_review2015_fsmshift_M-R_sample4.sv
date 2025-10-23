module TopModule (
    input clk,
    input reset,
    output shift_ena
);
    typedef enum logic [0:0] {IDLE=1'b0, ACTIVE=1'b1} state_t;
    state_t state, next_state;
    reg [1:0] count; // 2-bit counter to count 4 cycles

    // State and counter update
    always @(posedge clk) begin
        if (reset) begin
            state <= ACTIVE;
            count <= 2'd3;  // count from 3 down to 0 = 4 cycles total
        end else begin
            state <= next_state;
            if (state == ACTIVE)
                count <= count - 1;
            else
                count <= count;
        end
    end

    // Next state logic
    always @(*) begin
        case(state)
            ACTIVE: next_state = (count == 0) ? IDLE : ACTIVE;
            IDLE: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Output logic
    assign shift_ena = (state == ACTIVE);

endmodule