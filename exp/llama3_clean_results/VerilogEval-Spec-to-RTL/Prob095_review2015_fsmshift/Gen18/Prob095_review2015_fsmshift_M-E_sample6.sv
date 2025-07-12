module TopModule(
    input  logic clk,
    input  logic reset,
    output logic shift_ena
);

    enum logic [1:0] {IDLE, SHIFT_1, SHIFT_2, SHIFT_3, SHIFT_4} state, next_state;

    always_comb begin
        case (state)
            IDLE: next_state = reset ? SHIFT_1 : IDLE;
            SHIFT_1: next_state = SHIFT_2;
            SHIFT_2: next_state = SHIFT_3;
            SHIFT_3: next_state = SHIFT_4;
            SHIFT_4: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    assign shift_ena = (state != IDLE);

endmodule