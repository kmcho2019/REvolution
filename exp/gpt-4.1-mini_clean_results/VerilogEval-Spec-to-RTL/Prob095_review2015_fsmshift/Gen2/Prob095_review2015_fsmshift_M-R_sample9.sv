module TopModule(
    input  wire clk,
    input  wire reset,       // synchronous active-high reset
    output wire shift_ena
);

    typedef enum logic [1:0] {
        IDLE   = 2'b00,
        ENABLE = 2'b01
    } state_t;

    state_t state, next_state;
    reg [2:0] count, next_count;

    // State and counter registers
    always @(posedge clk) begin
        if (reset) begin
            state <= ENABLE;
            count <= 3'd4;
        end else begin
            state <= next_state;
            count <= next_count;
        end
    end

    // Next state and counter logic
    always @(*) begin
        next_state = state;
        next_count = count;

        case (state)
            IDLE: begin
                // Remain in IDLE forever until reset
                next_count = 3'd0;
            end

            ENABLE: begin
                if (count == 1) begin
                    next_state = IDLE; // after 4 cycles, disable
                    next_count = 3'd0;
                end else begin
                    next_count = count - 1;
                end
            end

            default: begin
                next_state = IDLE;
                next_count = 3'd0;
            end
        endcase
    end

    // Output logic: shift_ena asserted in ENABLE state
    assign shift_ena = (state == ENABLE);

endmodule