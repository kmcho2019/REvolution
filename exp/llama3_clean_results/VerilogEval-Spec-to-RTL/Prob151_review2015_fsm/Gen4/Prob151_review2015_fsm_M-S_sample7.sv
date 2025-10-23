module TopModule(
    input  clk,
    input  reset,
    input  data,
    input  done_counting,
    input  ack,
    output shift_ena,
    output counting,
    output done
);

enum logic [1:0] {
    IDLE,
    SHIFT,
    COUNTING,
    DONE_STATE
} state, next_state;

reg [1:0] shift_counter;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        shift_counter <= 2'b00;
    end else begin
        state <= next_state;
        case (state)
            SHIFT: shift_counter <= shift_counter + 1'b1;
            default: shift_counter <= 2'b00;
        endcase
    end
end

always @(*) begin
    case (state)
        IDLE: begin
            if (data == 1'b1) begin
                if (shift_counter == 2'b10) begin
                    next_state = SHIFT;
                end else begin
                    next_state = IDLE;
                end
                if (shift_counter!= 2'b10) begin
                    if (data == 1'b1) begin
                        shift_counter = shift_counter + 1'b1;
                    end else begin
                        shift_counter = 2'b00;
                    end
                end
            end else begin
                next_state = IDLE;
                shift_counter = 2'b00;
            end
        end
        SHIFT: begin
            if (shift_counter == 4) begin
                next_state = COUNTING;
            end else begin
                next_state = SHIFT;
            end
        end
        COUNTING: begin
            if (done_counting) begin
                next_state = DONE_STATE;
            end else begin
                next_state = COUNTING;
            end
        end
        DONE_STATE: begin
            if (ack) begin
                next_state = IDLE;
            end else begin
                next_state = DONE_STATE;
            end
        end
    endcase
end

assign shift_ena = (state == SHIFT);
assign counting = (state == COUNTING);
assign done = (state == DONE_STATE);

endmodule