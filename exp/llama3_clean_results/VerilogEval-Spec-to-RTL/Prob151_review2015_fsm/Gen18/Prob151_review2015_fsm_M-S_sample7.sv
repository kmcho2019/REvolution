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
    WAIT_ACK = 2'b11
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
        shift_ena <= 0;
        counting <= 0;
        done <= 0;
    end
    else begin
        case (state)
            IDLE: begin
                pattern_reg <= {pattern_reg[2:0], data};
                if (pattern_reg == 4'b1101) begin
                    state <= SHIFT;
                    shift_cnt <= 1;
                end
                else begin
                    state <= IDLE;
                end
                shift_ena <= 0;
                counting <= 0;
                done <= 0;
            end
            SHIFT: begin
                if (shift_cnt < 4) begin
                    shift_cnt <= shift_cnt + 1;
                    shift_ena <= 1;
                end
                else begin
                    state <= COUNT;
                    shift_ena <= 0;
                end
                counting <= 0;
                done <= 0;
            end
            COUNT: begin
                if (done_counting) begin
                    state <= WAIT_ACK;
                end
                counting <= 1;
                shift_ena <= 0;
                done <= 0;
            end
            WAIT_ACK: begin
                if (ack) begin
                    state <= IDLE;
                end
                done <= 1;
                shift_ena <= 0;
                counting <= 0;
            end
        endcase
    end
end

endmodule