module TopModule(
    input  logic clk,
    input  logic reset,
    output logic shift_ena
);

    enum logic [1:0] {
        IDLE,
        SHIFT_1,
        SHIFT_2,
        SHIFT_3,
        SHIFT_4
    } state, next_state;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= SHIFT_4;
        end else begin
            state <= next_state;
        end
    end

    always_comb begin
        case (state)
            IDLE: begin
                next_state = reset? SHIFT_4 : IDLE;
                shift_ena = 1'b0;
            end
            SHIFT_4: begin
                next_state = SHIFT_3;
                shift_ena = 1'b1;
            end
            SHIFT_3: begin
                next_state = SHIFT_2;
                shift_ena = 1'b1;
            end
            SHIFT_2: begin
                next_state = SHIFT_1;
                shift_ena = 1'b1;
            end
            SHIFT_1: begin
                next_state = IDLE;
                shift_ena = 1'b1;
            end
            default: begin
                next_state = IDLE;
                shift_ena = 1'b0;
            end
        endcase
    end

endmodule