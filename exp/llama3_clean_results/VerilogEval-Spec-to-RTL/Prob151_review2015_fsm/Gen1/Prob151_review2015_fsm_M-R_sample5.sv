module TopModule (
    input clk,
    input reset,
    input data,
    input done_counting,
    input ack,
    output reg shift_ena,
    output reg counting,
    output reg done
);

enum logic [1:0] {IDLE, SHIFT, COUNT, WAIT_DONE} state, next_state;
reg [3:0] shift_count;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        shift_count <= 0;
    end
    else begin
        state <= next_state;
        if (state == SHIFT) begin
            if (shift_count == 4) begin
                shift_count <= 0;
            end
            else begin
                shift_count <= shift_count + 1;
            end
        end
        else begin
            shift_count <= 0;
        end
    end
end

always @(*) begin
    case (state)
        IDLE: begin
            if (data == 1'b1 && shift_count == 0) begin
                next_state <= IDLE;
                shift_ena <= 0;
                counting <= 0;
                done <= 0;
                if (shift_count == 0 && data == 1'b1) begin
                    shift_count <= shift_count + 1;
                end
                else if (shift_count == 1 && data == 1'b0) begin
                    shift_count <= shift_count + 1;
                end
                else if (shift_count == 2 && data == 1'b1) begin
                    shift_count <= shift_count + 1;
                end
                else if (shift_count == 3 && data == 1'b0) begin
                    next_state <= SHIFT;
                    shift_count <= 0;
                end
                else begin
                    shift_count <= 0;
                end
            end
            else begin
                next_state <= IDLE;
                shift_ena <= 0;
                counting <= 0;
                done <= 0;
                shift_count <= 0;
            end
        end
        SHIFT: begin
            next_state <= (shift_count == 4)? COUNT : SHIFT;
            shift_ena <= 1;
            counting <= 0;
            done <= 0;
        end
        COUNT: begin
            next_state <= (done_counting)? WAIT_DONE : COUNT;
            shift_ena <= 0;
            counting <= 1;
            done <= 0;
        end
        WAIT_DONE: begin
            next_state <= (ack)? IDLE : WAIT_DONE;
            shift_ena <= 0;
            counting <= 0;
            done <= 1;
        end
        default: begin
            next_state <= IDLE;
            shift_ena <= 0;
            counting <= 0;
            done <= 0;
        end
    endcase
end

endmodule