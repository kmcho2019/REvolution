module TopModule(
    input  logic clk,
    input  logic reset,
    output logic shift_ena
);

    enum logic [1:0] {
        IDLE = 2'b00,
        SHIFT_ENABLE = 2'b01,
        COUNTING = 2'b10
    } state, next_state;

    logic [1:0] counter;

    always_comb begin
        case (state)
            IDLE: begin
                if (reset) begin
                    next_state = SHIFT_ENABLE;
                end else begin
                    next_state = IDLE;
                end
            end
            SHIFT_ENABLE: begin
                next_state = COUNTING;
            end
            COUNTING: begin
                if (counter == 2'd3) begin
                    next_state = IDLE;
                end else begin
                    next_state = COUNTING;
                end
            end
            default: next_state = IDLE;
        endcase
    end

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            counter <= 2'd0;
        end else begin
            state <= next_state;
            if (state == SHIFT_ENABLE) begin
                counter <= 2'd1;
            end else if (state == COUNTING) begin
                counter <= counter + 1;
            end
        end
    end

    always_comb begin
        case (state)
            IDLE: shift_ena = 0;
            SHIFT_ENABLE: shift_ena = 1;
            COUNTING: shift_ena = 1;
            default: shift_ena = 0;
        endcase
    end

endmodule