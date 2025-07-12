module TopModule (
    input clk,
    input reset,
    output shift_ena
);

    // State encoding
    localparam IDLE         = 1'b0;
    localparam SHIFT_ENABLE = 1'b1;

    reg state, next_state;
    reg [2:0] count, next_count;

    // Next state and next count logic
    always @(*) begin
        next_state = state;
        next_count = count;

        case(state)
            IDLE: begin
                if (reset) begin
                    next_state = SHIFT_ENABLE;
                    next_count = 3'd4;
                end
            end

            SHIFT_ENABLE: begin
                if (count == 1) begin
                    next_state = IDLE;
                    next_count = 3'd0;
                end else begin
                    next_count = count - 1;
                end
            end
        endcase
    end

    // State and count sequential update
    always @(posedge clk) begin
        if (reset) begin
            // Synchronize reset: go to SHIFT_ENABLE state with count=4
            state <= SHIFT_ENABLE;
            count <= 3'd4;
        end else begin
            state <= next_state;
            count <= next_count;
        end
    end

    // Output logic: shift_ena is asserted only in SHIFT_ENABLE state
    assign shift_ena = (state == SHIFT_ENABLE);

endmodule