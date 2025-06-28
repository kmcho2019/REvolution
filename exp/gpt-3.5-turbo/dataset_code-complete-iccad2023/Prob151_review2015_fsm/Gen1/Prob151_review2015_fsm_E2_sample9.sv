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
parameter DETECTED = 2'b01;
parameter WAIT_FOR_COUNTERS = 2'b10;
parameter TIMED_OUT = 2'b11;
parameter WAIT_FOR_ACK = 2'b100;

// Registers
reg [2:0] state, next_state;

// State machine
always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

// Next state logic and outputs
always @(*) begin
    shift_ena = 0;
    counting = 0;
    done = 0;

    case (state)
        IDLE:
            if (data == 4'b1101) begin
                next_state = DETECTED;
            end else begin
                next_state = IDLE;
            end
        DETECTED:
            if (shift_ena < 4) begin
                shift_ena = shift_ena + 1;
                next_state = (shift_ena == 4) ? WAIT_FOR_COUNTERS : DETECTED;
            end else begin
                next_state = WAIT_FOR_COUNTERS;
            end
        WAIT_FOR_COUNTERS:
            counting = 1;
            if (done_counting) begin
                next_state = TIMED_OUT;
            end else begin
                next_state = WAIT_FOR_COUNTERS;
            end
        TIMED_OUT:
            done = 1;
            if (ack) begin
                next_state = IDLE;
            end else begin
                next_state = TIMED_OUT;
            end
    endcase
end

endmodule