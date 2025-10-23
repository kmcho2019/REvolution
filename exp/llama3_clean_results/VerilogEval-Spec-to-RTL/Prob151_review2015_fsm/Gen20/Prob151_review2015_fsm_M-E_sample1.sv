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
    IDLE = 3'b000,
    PATTERN_DETECTION = 3'b001,
    SHIFTING = 3'b010,
    COUNTING = 3'b011,
    DONE_STATE = 3'b100
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
        case (state)
            IDLE: begin
                pattern_reg <= {pattern_reg[2:0], data};
                if (pattern_reg == 4'b1101) begin
                    state <= SHIFTING;
                    shift_cnt <= 0;
                end
                else begin
                    state <= IDLE;
                end
            end
            SHIFTING: begin
                shift_cnt <= shift_cnt + 1;
                if (shift_cnt == 4) begin
                    state <= COUNTING;
                end
                else begin
                    state <= SHIFTING;
                end
            end
            COUNTING: begin
                if (done_counting) begin
                    state <= DONE_STATE;
                end
                else begin
                    state <= COUNTING;
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
assign shift_ena = (state == SHIFTING);
assign counting = (state == COUNTING);
assign done = (state == DONE_STATE);

endmodule