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

// Define states
enum logic [2:0] {
    IDLE,
    SHIFT,
    COUNT,
    DONE
} state, next_state;

// Define counter for shift state
logic [1:0] shift_count;
logic [3:0] pattern;  // stores the detected pattern

// Detect pattern
always_ff @(posedge clk) begin
    if (reset) begin
        pattern <= 0;
    end else begin
        pattern <= {pattern[2:0], data};
    end
end

// Next state logic
always_comb begin
    case (state)
        IDLE: begin
            if (pattern == 4'b1101) begin
                next_state = SHIFT;
            end else begin
                next_state = IDLE;
            end
        end
        SHIFT: begin
            if (shift_count == 4'd3) begin
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
                next_state = IDLE;
            end else begin
                next_state = DONE;
            end
        end
        default: next_state = IDLE;
    endcase
end

// State register
always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        shift_count <= 0;
    end else begin
        state <= next_state;
        if (state == SHIFT) begin
            shift_count <= shift_count + 1;
        end else if (state == IDLE || state == COUNT) begin
            shift_count <= 0;
        end
    end
end

// Output logic
assign shift_ena = (state == SHIFT);
assign counting = (state == COUNT);
assign done = (state == DONE);

endmodule