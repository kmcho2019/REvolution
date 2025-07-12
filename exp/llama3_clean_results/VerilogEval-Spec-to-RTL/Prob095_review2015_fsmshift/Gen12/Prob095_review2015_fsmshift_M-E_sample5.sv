module TopModule(
    input  logic clk,
    input  logic reset,
    output logic shift_ena
);

    enum logic [1:0] {IDLE, SHIFT_ENABLE} state, next_state;
    logic [1:0] counter, next_counter;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            counter <= 2'b00;
            shift_ena <= 1'b0;
        end else begin
            state <= next_state;
            counter <= next_counter;
            shift_ena <= (state == SHIFT_ENABLE) ? 1'b1 : 1'b0;
        end
    end

    always_comb begin
        next_state = state;
        next_counter = counter;

        case (state)
            IDLE: begin
                if (reset) begin
                    next_state = SHIFT_ENABLE;
                    next_counter = 2'b00;
                end
            end
            SHIFT_ENABLE: begin
                next_counter = counter + 1;
                if (counter == 4'd3) begin
                    next_state = IDLE;
                end
            end
        endcase
    end

endmodule