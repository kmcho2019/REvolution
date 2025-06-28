module TopModule (
    input clk,
    input reset,
    input data,
    output reg shift_ena,
    output reg counting,
    input done_counting,
    output reg done,
    input ack
);

// Define states
parameter IDLE = 2'b00;
parameter DETECT_PATTERN = 2'b01;
parameter SHIFT_DELAY = 2'b10;
parameter WAIT_ACK = 2'b11;

// Registers for state machine
reg [1:0] state, next_state;

// State machine
always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

// Next state logic and outputs
always @* begin
    shift_ena = 0;
    counting = 0;
    done = 0;

    case (state)
        IDLE:
            if (data == 4'b1101) begin
                next_state = DETECT_PATTERN;
            end else begin
                next_state = IDLE;
            end
        DETECT_PATTERN:
            next_state = SHIFT_DELAY;
        SHIFT_DELAY:
            shift_ena = 1;
            next_state = WAIT_ACK;
        WAIT_ACK:
            if (done_counting) begin
                done = 1;
                if (ack) begin
                    next_state = IDLE;
                end else begin
                    next_state = WAIT_ACK;
                end
            end else begin
                next_state = WAIT_ACK;
            end
        default:
            next_state = IDLE;
    endcase
end

endmodule