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
parameter STATE_IDLE = 2'b00;
parameter STATE_DELAY_WAIT = 2'b01;

// Registers
reg [1:0] state, next_state;

// State machine
always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= STATE_IDLE;
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
        STATE_IDLE:
            if (data == 4'b1101) begin
                shift_ena = 1;
                next_state = STATE_DELAY_WAIT;
            end else begin
                shift_ena = 0;
                next_state = STATE_IDLE;
            end
        STATE_DELAY_WAIT:
            if (shift_ena == 4 && done_counting) begin
                done = 1;
                next_state = (ack) ? STATE_IDLE : STATE_DELAY_WAIT;
            end else begin
                shift_ena = (data == 4'b1101) ? 1 : (shift_ena == 4) ? 4 : shift_ena + 1;
                next_state = STATE_DELAY_WAIT;
            end
        default:
            next_state = STATE_IDLE;
    endcase
end

endmodule