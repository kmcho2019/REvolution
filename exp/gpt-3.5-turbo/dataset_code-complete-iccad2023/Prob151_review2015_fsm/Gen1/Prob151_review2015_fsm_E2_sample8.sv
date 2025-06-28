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
parameter STATE_DELAY = 2'b01;
parameter STATE_WAIT = 2'b10;
parameter STATE_DONE = 2'b11;

// Registers
reg [1:0] state, next_state;
reg [2:0] delay_counter; // 3-bit counter for shifting in 4 bits

// State machine
always @(posedge clk) begin
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
                next_state = STATE_DELAY;
                delay_counter <= 0;
            end else begin
                next_state = STATE_IDLE;
            end
        STATE_DELAY:
            if (delay_counter == 4) begin
                next_state = STATE_WAIT;
            end else begin
                shift_ena = 1; // Shift_ena asserted for 4 clock cycles
                delay_counter <= delay_counter + 1;
                next_state = STATE_DELAY;
            end
        STATE_WAIT:
            if (done_counting) begin
                next_state = STATE_DONE;
            end else begin
                next_state = STATE_WAIT;
            end
        STATE_DONE:
            if (ack) begin
                next_state = STATE_IDLE;
            end else begin
                done = 1;
                next_state = STATE_DONE;
            end
        default:
            next_state = STATE_IDLE;
    endcase
end

endmodule