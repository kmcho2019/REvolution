module TopModule(
    input         clk,
    input         reset,
    input         data,
    input         done_counting,
    input         ack,
    output        shift_ena,
    output        counting,
    output        done
);

// Define states
enum logic [2:0] {
    S_IDLE,
    S_SHIFT,
    S_COUNT,
    S_DONE
} state, next_state;

// Define counter for shifting
logic [1:0] shift_count;
logic [3:0] pattern;

always_comb begin
    // Default values
    shift_ena = 1'b0;
    counting = 1'b0;
    done = 1'b0;
    
    case(state)
        S_IDLE: begin
            if (pattern == 4'b1101) begin
                next_state = S_SHIFT;
            end else begin
                next_state = S_IDLE;
            end
        end
        S_SHIFT: begin
            shift_ena = 1'b1;
            if (shift_count == 4'd3) begin
                next_state = S_COUNT;
            end else begin
                next_state = S_SHIFT;
            end
        end
        S_COUNT: begin
            counting = 1'b1;
            if (done_counting) begin
                next_state = S_DONE;
            end else begin
                next_state = S_COUNT;
            end
        end
        S_DONE: begin
            done = 1'b1;
            if (ack) begin
                next_state = S_IDLE;
            end else begin
                next_state = S_DONE;
            end
        end
        default: next_state = S_IDLE;
    endcase
end

always_ff @(posedge clk) begin
    if (reset) begin
        state <= S_IDLE;
        shift_count <= 4'd0;
        pattern <= 4'd0;
    end else begin
        state <= next_state;
        if (state == S_SHIFT) begin
            shift_count <= shift_count + 1'd1;
            pattern <= {pattern[2:0], data};
        end else if (state == S_IDLE) begin
            pattern <= {pattern[2:0], data};
            shift_count <= 4'd0;
        end else if (state == S_DONE) begin
            pattern <= 4'd0;
            shift_count <= 4'd0;
        end
    end
end

endmodule