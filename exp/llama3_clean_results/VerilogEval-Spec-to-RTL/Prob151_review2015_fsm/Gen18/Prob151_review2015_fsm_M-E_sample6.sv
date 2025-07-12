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
enum logic [2:0] {
    IDLE_SEARCH = 3'b001,
    SHIFT_SHIFTING = 3'b010,
    SHIFT_DONE = 3'b011,
    COUNT_WAITING = 3'b100,
    WAIT_ACK_WAITING = 3'b101
} state, next_state;

// Pattern detection register
reg [3:0] pattern_reg;

// Shift counter
reg [1:0] shift_cnt;

// Continuous assignment for output signals
assign shift_ena = (state == SHIFT_SHIFTING);
assign counting = (state == COUNT_WAITING);
assign done = (state == WAIT_ACK_WAITING);

// Sequential logic for state and counter updates
always @(posedge clk) begin
    if (reset) begin
        state <= IDLE_SEARCH;
        pattern_reg <= 0;
        shift_cnt <= 0;
    end
    else begin
        pattern_reg <= {pattern_reg[2:0], data};
        case (state)
            IDLE_SEARCH: begin
                if (pattern_reg == 4'b1101) begin
                    state <= SHIFT_SHIFTING;
                    shift_cnt <= 1;
                end
                else begin
                    state <= IDLE_SEARCH;
                end
            end
            SHIFT_SHIFTING: begin
                shift_cnt <= shift_cnt + 1;
                if (shift_cnt == 4) begin
                    state <= SHIFT_DONE;
                end
                else begin
                    state <= SHIFT_SHIFTING;
                end
            end
            SHIFT_DONE: begin
                state <= COUNT_WAITING;
            end
            COUNT_WAITING: begin
                if (done_counting) begin
                    state <= WAIT_ACK_WAITING;
                end
                else begin
                    state <= COUNT_WAITING;
                end
            end
            WAIT_ACK_WAITING: begin
                if (ack) begin
                    state <= IDLE_SEARCH;
                end
                else begin
                    state <= WAIT_ACK_WAITING;
                end
            end
        endcase
    end
end

endmodule