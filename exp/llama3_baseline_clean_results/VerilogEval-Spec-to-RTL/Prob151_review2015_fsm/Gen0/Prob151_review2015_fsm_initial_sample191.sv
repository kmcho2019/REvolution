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

// Define states
parameter IDLE = 0;
parameter SHIFT = 1;
parameter COUNTING = 2;
parameter DONE = 3;

// State register
reg [1:0] state;
reg [1:0] next_state;

// Counter for Shift state
reg [1:0] shift_cnt;
reg [1:0] next_shift_cnt;

// Pattern detection
reg [3:0] pattern;
reg [3:0] next_pattern;

always @(*) begin
    // Default assignments
    next_state = state;
    next_shift_cnt = shift_cnt;
    next_pattern = {data, pattern[3:1]};

    case(state)
        IDLE: begin
            if (next_pattern == 4'b1101) begin
                next_state = SHIFT;
                next_shift_cnt = 0;
            end else begin
                next_state = IDLE;
            end
        end
        SHIFT: begin
            next_shift_cnt = shift_cnt + 1;
            if (next_shift_cnt == 4) begin
                next_state = COUNTING;
            end else begin
                next_state = SHIFT;
            end
        end
        COUNTING: begin
            if (done_counting) begin
                next_state = DONE;
            end else begin
                next_state = COUNTING;
            end
        end
        DONE: begin
            if (ack) begin
                next_state = IDLE;
            end else begin
                next_state = DONE;
            end
        end
    endcase
end

// Output logic
always @(*) begin
    case(state)
        IDLE: begin
            shift_ena = 0;
            counting = 0;
            done = 0;
        end
        SHIFT: begin
            shift_ena = 1;
            counting = 0;
            done = 0;
        end
        COUNTING: begin
            shift_ena = 0;
            counting = 1;
            done = 0;
        end
        DONE: begin
            shift_ena = 0;
            counting = 0;
            done = 1;
        end
    endcase
end

// Sequential logic
always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        shift_cnt <= 0;
        pattern <= 0;
    end else begin
        state <= next_state;
        shift_cnt <= next_shift_cnt;
        pattern <= next_pattern;
    end
end

endmodule