module TopModule(
    input  logic clk,
    input  logic reset,
    output logic shift_ena
);

    enum logic [1:0] {IDLE, SHIFT_COUNTING, SHIFT_DISABLE} state, next_state;
    logic [2:0] count, next_count;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            count <= 3'b000;
        end
        else begin
            state <= next_state;
            count <= next_count;
        end
    end

    always_comb begin
        case(state)
            IDLE: begin
                if (reset) begin
                    next_state = SHIFT_COUNTING;
                    next_count = 3'b000;
                    shift_ena = 1'b1;
                end
                else begin
                    next_state = IDLE;
                    next_count = 3'b000;
                    shift_ena = 1'b0;
                end
            end
            SHIFT_COUNTING: begin
                shift_ena = 1'b1;
                next_count = count + 1'b1;
                if (count == 3'b111) begin
                    next_state = SHIFT_DISABLE;
                end
                else begin
                    next_state = SHIFT_COUNTING;
                end
            end
            SHIFT_DISABLE: begin
                shift_ena = 1'b0;
                next_state = SHIFT_DISABLE;
                next_count = 3'b000;
            end
            default: begin
                next_state = IDLE;
                next_count = 3'b000;
                shift_ena = 1'b0;
            end
        endcase
    end

endmodule