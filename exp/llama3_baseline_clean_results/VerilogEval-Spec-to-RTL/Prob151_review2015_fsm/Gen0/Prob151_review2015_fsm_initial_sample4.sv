module TopModule(
    input clk,
    input reset,
    input data,
    input done_counting,
    input ack,
    output shift_ena,
    output counting,
    output done
);

// Define the states
enum logic [2:0] {
    IDLE,
    SHIFT1,
    SHIFT2,
    SHIFT3,
    SHIFT4,
    COUNTING,
    DONE
} state, next_state;

// Sequential logic
always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

// Combinational logic
always_comb begin
    next_state = state;
    shift_ena = 1'b0;
    counting = 1'b0;
    done = 1'b0;

    case (state)
        IDLE: begin
            if (data == 1'b1 && /* pattern detection logic */) begin
                next_state = SHIFT1;
            end
        end
        SHIFT1: begin
            shift_ena = 1'b1;
            next_state = SHIFT2;
        end
        SHIFT2: begin
            shift_ena = 1'b1;
            next_state = SHIFT3;
        end
        SHIFT3: begin
            shift_ena = 1'b1;
            next_state = SHIFT4;
        end
        SHIFT4: begin
            shift_ena = 1'b1;
            next_state = COUNTING;
        end
        COUNTING: begin
            counting = 1'b1;
            if (done_counting) begin
                next_state = DONE;
            end
        end
        DONE: begin
            done = 1'b1;
            if (ack) begin
                next_state = IDLE;
            end
        end
        default: next_state = IDLE;
    endcase
end

// Pattern detection logic
logic [3:0] pattern;
always_ff @(posedge clk) begin
    if (reset) begin
        pattern = 4'b0;
    end else if (state == IDLE) begin
        pattern = {pattern[2:0], data};
        if (pattern == 4'b1101) begin
            next_state = SHIFT1;
        end
    end else begin
        pattern = 4'b0;
    end
end

endmodule