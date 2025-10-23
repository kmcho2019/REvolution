module TopModule (
    input  wire clk,
    input  wire reset,
    output reg  shift_ena
);

    typedef enum logic [0:0] {IDLE=1'b0, ENABLE_SHIFT=1'b1} state_t;
    state_t state, next_state;

    reg [1:0] cycle_count; // 2-bit counter to count 0..3 cycles

    // State and cycle_count update
    always @(posedge clk) begin
        if (reset) begin
            state <= ENABLE_SHIFT;
            cycle_count <= 2'b00;
        end else begin
            state <= next_state;
            if (state == ENABLE_SHIFT)
                cycle_count <= cycle_count + 1;
            else
                cycle_count <= 2'b00;
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: next_state = IDLE;
            ENABLE_SHIFT: 
                if (cycle_count == 2'd3)
                    next_state = IDLE;
                else
                    next_state = ENABLE_SHIFT;
            default: next_state = IDLE;
        endcase
    end

    // Output logic
    always @(*) begin
        shift_ena = (state == ENABLE_SHIFT);
    end

endmodule