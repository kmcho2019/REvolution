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

// Define the states
parameter IDLE = 2'b00;
parameter SHIFT = 2'b01;
parameter COUNT = 2'b10;
parameter DONE_ACK = 2'b11;

// State register
reg [1:0] state;
reg [1:0] next_state;

// Pattern register
reg [3:0] pattern;
reg [3:0] next_pattern;

// Shift counter
reg [1:0] shift_cnt;
reg [1:0] next_shift_cnt;

always @(*) begin
    // Default values
    next_state = state;
    next_pattern = pattern;
    next_shift_cnt = shift_cnt;
    shift_ena = 0;
    counting = 0;
    done = 0;

    case (state)
        IDLE: begin
            next_pattern = {pattern[2:0], data};
            if (pattern == 4'b1101) begin
                next_state = SHIFT;
                next_shift_cnt = 1;
            end
        end
        SHIFT: begin
            shift_ena = 1;
            next_shift_cnt = shift_cnt + 1;
            if (shift_cnt == 4) begin
                next_state = COUNT;
            end
        end
        COUNT: begin
            counting = 1;
            if (done_counting) begin
                next_state = DONE_ACK;
            end
        end
        DONE_ACK: begin
            done = 1;
            if (ack) begin
                next_state = IDLE;
            end
        end
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        pattern <= 0;
        shift_cnt <= 0;
    end
    else begin
        state <= next_state;
        pattern <= next_pattern;
        shift_cnt <= next_shift_cnt;
    end
end

endmodule