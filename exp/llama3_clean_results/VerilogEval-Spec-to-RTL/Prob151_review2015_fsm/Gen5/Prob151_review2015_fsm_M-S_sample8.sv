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

enum logic [2:0] {
    IDLE,
    SHIFT,
    COUNTING,
    DONE_STATE
} state, next_state;

reg [3:0] shift_register;
reg [3:0] duration;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        shift_register <= 4'b0000;
        duration <= 4'b0000;
    end else begin
        state <= next_state;
        case (state)
            IDLE: begin
                shift_register <= {shift_register[2:0], data};
                if (shift_register == 4'b1101) begin
                    next_state <= SHIFT;
                end else begin
                    next_state <= IDLE;
                end
            end
            SHIFT: begin
                shift_register <= {shift_register[2:0], data};
                if (shift_register[3:0] == 4'bxxxx) begin
                    duration <= shift_register;
                    next_state <= COUNTING;
                end else begin
                    next_state <= SHIFT;
                end
            end
            COUNTING: begin
                if (done_counting) begin
                    next_state <= DONE_STATE;
                end else begin
                    next_state <= COUNTING;
                end
            end
            DONE_STATE: begin
                if (ack) begin
                    next_state <= IDLE;
                end else begin
                    next_state <= DONE_STATE;
                end
            end
        endcase
    end
end

always @(posedge clk) begin
    case (state)
        SHIFT: begin
            if (shift_register[3:0] == 4'bxxxx) begin
                shift_ena <= 1'b0;
            end else begin
                shift_ena <= 1'b1;
            end
        end
        default: shift_ena <= 1'b0;
    endcase
    case (state)
        COUNTING: counting <= 1'b1;
        default: counting <= 1'b0;
    endcase
    case (state)
        DONE_STATE: done <= 1'b1;
        default: done <= 1'b0;
    endcase
end

endmodule