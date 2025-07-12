module TopModule(
    input  logic clk,
    input  logic reset,
    output logic shift_ena
);

    enum logic [1:0] {IDLE, SHIFT_ENABLED} state, next_state;
    logic [1:0] counter = 0;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= SHIFT_ENABLED;
            counter <= 4;
        end else begin
            state <= next_state;
            if (state == SHIFT_ENABLED) begin
                counter <= counter - 1;
            end
        end
    end

    always_comb begin
        case (state)
            IDLE: begin
                shift_ena = 0;
                next_state = IDLE;
                if (reset) begin
                    next_state = SHIFT_ENABLED;
                end
            end
            SHIFT_ENABLED: begin
                shift_ena = 1;
                next_state = SHIFT_ENABLED;
                if (counter == 0) begin
                    next_state = IDLE;
                end
            end
        endcase
    end

endmodule