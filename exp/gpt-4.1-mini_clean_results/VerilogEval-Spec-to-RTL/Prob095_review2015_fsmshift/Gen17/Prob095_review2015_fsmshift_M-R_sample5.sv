module TopModule (
    input  wire clk,
    input  wire reset,       // synchronous active-high reset
    output wire shift_ena
);

    // FSM states
    typedef enum logic [0:0] {
        IDLE     = 1'b0,
        SHIFT_EN = 1'b1
    } state_t;

    state_t state, next_state;
    reg [2:0] cycle_count; // counts from 0 up to 3 (4 cycles total)

    // State and counter sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= SHIFT_EN;
            cycle_count <= 3'd0;
        end else begin
            state <= next_state;
            if (state == SHIFT_EN) begin
                cycle_count <= cycle_count + 1'b1;
            end else begin
                cycle_count <= 3'd0;
            end
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            SHIFT_EN: begin
                if (cycle_count == 3'd3) // after 4 cycles (0..3)
                    next_state = IDLE;
                else
                    next_state = SHIFT_EN;
            end
            IDLE: begin
                next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

    // Output combinational logic
    assign shift_ena = (state == SHIFT_EN);

endmodule