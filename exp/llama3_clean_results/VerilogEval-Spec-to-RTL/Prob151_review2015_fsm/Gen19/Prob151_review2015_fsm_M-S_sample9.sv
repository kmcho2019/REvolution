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

// Pattern detection
reg [3:0] pattern;

// Shift counter
reg [1:0] shift_cnt;

// Next state logic
always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        pattern <= 0;
        shift_cnt <= 0;
    end
    else begin
        state <= next_state;
        case (state)
            IDLE: begin
                pattern <= {pattern[2:0], data};
            end
            SHIFT: begin
                shift_cnt <= shift_cnt + 1;
            end
            default: begin
                // No need to update pattern or shift_cnt in other states
            end
        endcase
    end
end

// Combinational logic for next state
always @(*) begin
    next_state = state;
    case (state)
        IDLE: begin
            if (pattern == 4'b1101) begin
                next_state = SHIFT;
            end
        end
        SHIFT: begin
            if (shift_cnt == 4) begin
                next_state = COUNT;
            end
        end
        COUNT: begin
            if (done_counting) begin
                next_state = DONE_ACK;
            end
        end
        DONE_ACK: begin
            if (ack) begin
                next_state = IDLE;
            end
        end
    endcase
end

// Output logic
always @(posedge clk) begin
    case (state)
        SHIFT: shift_ena <= (shift_cnt < 4)? 1'b1 : 1'b0;
        default: shift_ena <= 1'b0;
    endcase
    counting <= (state == COUNT);
    done <= (state == DONE_ACK);
end

endmodule