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
enum logic [1:0] {
    IDLE,
    SHIFT,
    COUNT,
    DONE_ACK
} state, next_state;

// Pattern detection
reg [3:0] pattern;

// Shift counter
reg [1:0] shift_cnt;

// Next state logic and output logic
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
                if (pattern == 4'b1101) begin
                    next_state <= SHIFT;
                end
                else begin
                    next_state <= IDLE;
                end
            end
            SHIFT: begin
                shift_cnt <= shift_cnt + 1;
                if (shift_cnt == 4) begin
                    next_state <= COUNT;
                end
                else begin
                    next_state <= SHIFT;
                end
            end
            COUNT: begin
                if (done_counting) begin
                    next_state <= DONE_ACK;
                end
                else begin
                    next_state <= COUNT;
                end
            end
            DONE_ACK: begin
                if (ack) begin
                    next_state <= IDLE;
                end
                else begin
                    next_state <= DONE_ACK;
                end
            end
        endcase
    end
end

// Output logic using assign
assign shift_ena = (state == SHIFT) && (shift_cnt < 4);
assign counting = (state == COUNT);
assign done = (state == DONE_ACK);

endmodule