module TopModule(
    input  logic clk,
    input  logic reset,
    output logic shift_ena
);

    enum logic [1:0] {IDLE, SHIFT_ENABLE, SHIFT_ENABLE_1, SHIFT_ENABLE_2, SHIFT_ENABLE_3} state;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end
        else begin
            case (state)
                IDLE: state <= IDLE;
                SHIFT_ENABLE: state <= SHIFT_ENABLE_1;
                SHIFT_ENABLE_1: state <= SHIFT_ENABLE_2;
                SHIFT_ENABLE_2: state <= SHIFT_ENABLE_3;
                SHIFT_ENABLE_3: state <= IDLE;
                default: state <= IDLE;
            endcase
        end
    end

    always_comb begin
        case (state)
            IDLE: shift_ena = 1'b0;
            SHIFT_ENABLE, SHIFT_ENABLE_1, SHIFT_ENABLE_2, SHIFT_ENABLE_3: shift_ena = 1'b1;
            default: shift_ena = 1'b0;
        endcase
    end

endmodule