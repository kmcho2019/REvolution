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

// Define states
enum logic [2:0] {
    SEARCH,
    SHIFT,
    COUNT,
    DONE
} state, next_state;

// Pattern detection variables
logic [3:0] pattern_detected = 0;

// Shift counter
logic [1:0] shift_count = 0;

always_ff @(posedge clk) begin
    if (reset) begin
        state <= SEARCH;
        pattern_detected <= 0;
        shift_count <= 0;
    end else begin
        state <= next_state;
        pattern_detected <= (data ? pattern_detected << 1 : 0) | data;
        if (state == SHIFT) begin
            shift_count <= shift_count + 1;
        end else if (state == SEARCH) begin
            shift_count <= 0;
        end
    end
end

always_comb begin
    case (state)
        SEARCH: begin
            if (pattern_detected == 4'b1101) begin
                next_state = SHIFT;
            end else begin
                next_state = SEARCH;
            end
        end
        SHIFT: begin
            if (shift_count == 4) begin
                next_state = COUNT;
            end else begin
                next_state = SHIFT;
            end
        end
        COUNT: begin
            if (done_counting) begin
                next_state = DONE;
            end else begin
                next_state = COUNT;
            end
        end
        DONE: begin
            if (ack) begin
                next_state = SEARCH;
            end else begin
                next_state = DONE;
            end
        end
        default: next_state = SEARCH;
    endcase
end

always_comb begin
    shift_ena = (state == SHIFT) ? 1 : 0;
    counting = (state == COUNT) ? 1 : 0;
    done = (state == DONE) ? 1 : 0;
end

endmodule