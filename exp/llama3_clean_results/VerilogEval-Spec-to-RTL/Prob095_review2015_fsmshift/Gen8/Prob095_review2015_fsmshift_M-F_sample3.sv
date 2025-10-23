module TopModule(
    input  logic clk,
    input  logic reset,
    output logic shift_ena
);

    enum logic [1:0] {
        IDLE = 2'b00,
        SHIFT_ENABLE_1 = 2'b01,
        SHIFT_ENABLE_2 = 2'b10,
        SHIFT_ENABLE_3 = 2'b11
    } state, next_state;

    always_comb begin
        case (state)
            IDLE: begin
                if (reset) begin
                    next_state = SHIFT_ENABLE_1;
                end else begin
                    next_state = IDLE;
                end
            end
            SHIFT_ENABLE_1: begin
                next_state = SHIFT_ENABLE_2;
            end
            SHIFT_ENABLE_2: begin
                next_state = SHIFT_ENABLE_3;
            end
            SHIFT_ENABLE_3: begin
                if (reset) begin
                    next_state = SHIFT_ENABLE_1;
                end else begin
                    next_state = IDLE;
                end
            end
            default: next_state = IDLE;
        endcase
    end

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= SHIFT_ENABLE_1;
        end else begin
            state <= next_state;
        end
    end

    always_comb begin
        case (state)
            IDLE: shift_ena = 0;
            SHIFT_ENABLE_1: shift_ena = 1;
            SHIFT_ENABLE_2: shift_ena = 1;
            SHIFT_ENABLE_3: shift_ena = 1;
            default: shift_ena = 0;
        endcase
    end

endmodule