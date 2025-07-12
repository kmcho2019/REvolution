module TopModule (
    input clk,
    input reset,
    output shift_ena
);

    typedef enum logic [0:0] {DISABLE = 1'b0, ENABLE = 1'b1} state_t;
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
    always @* begin
        next_state = state;
        next_count = count;

        case (state)
            ENABLE: begin
                if (count != 3'd0)
                    next_count = count - 1;
                if (count == 3'd1)
                    next_state = DISABLE;
            end
            DISABLE: begin
                next_count = 3'd0;
                // Remain in DISABLE until reset
            end
        endcase
    end

    // Output logic
    assign shift_ena = (state == ENABLE);

endmodule