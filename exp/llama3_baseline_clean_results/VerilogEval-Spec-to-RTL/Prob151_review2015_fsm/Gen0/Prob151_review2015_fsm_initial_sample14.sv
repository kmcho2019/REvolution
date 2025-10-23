module TopModule (
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
    COUNT,
    DONE
} state, next_state;

logic [3:0] shift_count;

always_comb begin
    next_state = state;
    shift_ena = 1'b0;
    counting = 1'b0;
    done = 1'b0;

    case (state)
        IDLE: begin
            // Start shifting in when the pattern is detected
            if (data == 1'b1) begin
                next_state = SHIFT;
                shift_ena = 1'b1;
            end
        end
        SHIFT: begin
            shift_ena = 1'b1;
            // Finish shifting after 4 clock cycles
            if (shift_count == 4'b1000) begin
                next_state = COUNT;
                counting = 1'b1;
            end
        end
        COUNT: begin
            counting = 1'b1;
            // Move to DONE when the counters are done
            if (done_counting) begin
                next_state = DONE;
                done = 1'b1;
            end
        end
        DONE: begin
            done = 1'b1;
            // Reset to IDLE when ack is received
            if (ack) begin
                next_state = IDLE;
            end
        end
        default: next_state = IDLE;
    endcase
end

always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        shift_count <= 4'b0000;
    end else begin
        state <= next_state;
        if (state == SHIFT) begin
            shift_count <= shift_count + 1'b1;
        end else if (state == IDLE) begin
            shift_count <= 4'b0000;
        end
    end
end

endmodule