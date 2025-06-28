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
parameter DELAY = 2'b01;
parameter WAIT = 2'b10;
parameter DONE = 2'b11;

// Registers
reg [1:0] state, next_state;

// State machine
always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

// Next state logic and outputs
always @(*) begin
    // Default outputs
    shift_ena = 0;
    counting = 0;
    done = 0;

    case (state)
        IDLE:
            if (data == 4'b1101) begin
                next_state = DELAY;
            end else begin
                next_state = IDLE;
            end
        DELAY:
            if (shift_ena < 4) begin
                shift_ena = shift_ena + 1;
                next_state = DELAY;
            end else begin
                shift_ena = 0;
                next_state = WAIT;
            end
        WAIT:
            counting = 1;
            if (done_counting) begin
                next_state = DONE;
            end else begin
                next_state = WAIT;
            end
        DONE:
            done = 1;
            if (ack) begin
                next_state = IDLE;
            end else begin
                next_state = DONE;
            end
        default:
            next_state = IDLE;
    endcase
end

endmodule