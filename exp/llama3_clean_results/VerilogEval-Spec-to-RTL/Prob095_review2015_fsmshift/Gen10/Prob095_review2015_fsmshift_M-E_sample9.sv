module TopModule(
    input  logic clk,
    input  logic reset,
    output logic shift_ena
);

    enum logic [1:0] {IDLE, COUNTDOWN, DISABLED} state, next_state;
    logic [1:0] countdown;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= COUNTDOWN;
            countdown <= 4;
        end else begin
            state <= next_state;
            if (state == COUNTDOWN) begin
                countdown <= countdown - 1;
                if (countdown == 0) begin
                    state <= DISABLED;
                end
            end
        end
    end

    always_comb begin
        case (state)
            IDLE: begin
                next_state = reset ? COUNTDOWN : IDLE;
                shift_ena = 1'b0;
            end
            COUNTDOWN: begin
                next_state = (countdown == 1) ? DISABLED : COUNTDOWN;
                shift_ena = 1'b1;
            end
            DISABLED: begin
                next_state = reset ? COUNTDOWN : DISABLED;
                shift_ena = 1'b0;
            end
        endcase
    end

endmodule