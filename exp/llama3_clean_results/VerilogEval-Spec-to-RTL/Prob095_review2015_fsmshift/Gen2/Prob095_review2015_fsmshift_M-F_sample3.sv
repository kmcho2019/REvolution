module TopModule(
    input  logic clk,
    input  logic reset,
    output logic shift_ena
);

    enum logic [1:0] {IDLE, SHIFT_COUNTING, SHIFT_DISABLE} state, next_state;
    logic [1:0] count, next_count;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= SHIFT_COUNTING;
            count <= 2'b11; // Set count to 3 to enable shift_ena for 4 cycles
        end
        else begin
            state <= next_state;
            count <= next_count;
        end
    end

    always_comb begin
        case(state)
            IDLE: begin
                next_state = IDLE;
                next_count = 2'b00;
                shift_ena = 1'b0;
            end
            SHIFT_COUNTING: begin
                shift_ena = 1'b1;
                if (count == 2'b00) begin
                    next_state = SHIFT_DISABLE;
                end
                else begin
                    next_state = SHIFT_COUNTING;
                end
                next_count = count - 1'b1; // Decrement count
            end
            SHIFT_DISABLE: begin
                shift_ena = 1'b0;
                next_state = SHIFT_DISABLE;
                next_count = count;
            end
            default: begin
                next_state = IDLE;
                next_count = 2'b00;
                shift_ena = 1'b0;
            end
        endcase
    end

endmodule