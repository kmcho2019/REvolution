module TopModule(
    input logic clk,
    input logic reset,
    input logic data,
    input logic done_counting,
    input logic ack,
    output logic shift_ena,
    output logic counting,
    output logic done
);

    enum logic [2:0] {IDLE, SHIFT, COUNT, DONE_WAIT} state, next_state;
    logic [3:0] shift_cnt;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            shift_cnt <= 4'b0;
        end else begin
            state <= next_state;
            if (state == SHIFT && shift_ena) begin
                shift_cnt <= shift_cnt - 1'b1;
            end else if (state == IDLE) begin
                shift_cnt <= 4'b100;
            end
        end
    end

    always_comb begin
        next_state = state;
        case (state)
            IDLE: begin
                // detect the pattern 1101
                if (data == 1'b1 && $past(data) == 1'b0 && $past($past(data)) == 1'b1 && $past($past($past(data))) == 1'b1) begin
                    next_state = SHIFT;
                end
            end
            SHIFT: begin
                shift_ena = 1'b1;
                if (shift_cnt == 1'b0) begin
                    next_state = COUNT;
                end
            end
            COUNT: begin
                counting = 1'b1;
                if (done_counting) begin
                    next_state = DONE_WAIT;
                end
            end
            DONE_WAIT: begin
                done = 1'b1;
                if (ack) begin
                    next_state = IDLE;
                end
            end
            default: next_state = IDLE;
        endcase
    end

    assign counting = (state == COUNT);
    assign done = (state == DONE_WAIT);
    assign shift_ena = (state == SHIFT);
endmodule