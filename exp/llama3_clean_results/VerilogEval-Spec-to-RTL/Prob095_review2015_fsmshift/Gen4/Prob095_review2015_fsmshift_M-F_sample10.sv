module TopModule(
    input  logic clk,
    input  logic reset,
    output logic shift_ena
);

    enum logic [1:0] {IDLE, RESET_SHIFT_COUNTING} state, next_state;
    logic [1:0] count, next_count;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= RESET_SHIFT_COUNTING;
            count <= 2'b11; // Count starts from 3
        end
        else begin
            state <= next_state;
            count <= next_count;
        end
    end

    always_comb begin
        case(state)
            IDLE: begin
                next_state = reset ? RESET_SHIFT_COUNTING : IDLE;
                next_count = reset ? 2'b11 : 2'b00;
                shift_ena = 1'b0;
            end
            RESET_SHIFT_COUNTING: begin
                shift_ena = 1'b1;
                if (count == 2'b00) begin
                    next_state = IDLE;
                    next_count = 2'b00;
                end
                else begin
                    next_state = RESET_SHIFT_COUNTING;
                    next_count = count - 2'b01; // Explicit cast for subtraction
                end
            end
            default: begin
                next_state = IDLE;
                next_count = 2'b00;
                shift_ena = 1'b0;
            end
        endcase
    end

endmodule