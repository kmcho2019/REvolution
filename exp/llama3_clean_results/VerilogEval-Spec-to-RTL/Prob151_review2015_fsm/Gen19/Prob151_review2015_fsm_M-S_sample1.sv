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
    IDLE = 2'b00,
    SHIFT = 2'b01,
    COUNT = 2'b10,
    DONE_STATE = 2'b11
} state, next_state;

// Pattern detection register
reg [3:0] pattern_reg;

// Shift counter
reg [1:0] shift_cnt;

// Sequential logic for state and counter updates
always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        pattern_reg <= 0;
        shift_cnt <= 0;
    end
    else begin
        pattern_reg <= {pattern_reg[2:0], data};
        case (state)
            IDLE: begin
                if (pattern_reg == 4'b1101) begin
                    state <= SHIFT;
                    shift_cnt <= 1;
                end
                else begin
                    state <= IDLE;
                end
            end
            SHIFT: begin
                shift_cnt <= shift_cnt + 1;
                if (shift_cnt == 4) begin
                    state <= COUNT;
                end
                else begin
                    state <= SHIFT;
                end
            end
            COUNT: begin
                if (done_counting) begin
                    state <= DONE_STATE;
                end
                else begin
                    state <= COUNT;
                end
            end
            DONE_STATE: begin
                if (ack) begin
                    state <= IDLE;
                end
                else begin
                    state <= DONE_STATE;
                end
            end
        endcase
    end
end

// Continuous assignment for output signals
assign shift_ena = (state == SHIFT);
assign counting = (state == COUNT);
assign done = (state == DONE_STATE);

endmodule