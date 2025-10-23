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

// Combinational logic for next state
always_comb begin
    case (state)
        IDLE: begin
            if (pattern_reg == 4'b1101) begin
                next_state = SHIFT;
            end
            else begin
                next_state = IDLE;
            end
        end
        SHIFT: begin
            if (shift_cnt == 4) begin
                next_state = COUNT;
            end
            else begin
                next_state = SHIFT;
            end
        end
        COUNT: begin
            if (done_counting) begin
                next_state = WAIT_ACK;
            end
            else begin
                next_state = COUNT;
            end
        end
        WAIT_ACK: begin
            if (ack) begin
                next_state = IDLE;
            end
            else begin
                next_state = WAIT_ACK;
            end
        end
    endcase
end

// Sequential logic for state and counter updates
always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        pattern_reg <= 0;
        shift_cnt <= 0;
    end
    else begin
        pattern_reg <= {pattern_reg[2:0], data};
        state <= next_state;
        if (state == SHIFT) begin
            shift_cnt <= shift_cnt + 1;
        end
        else begin
            shift_cnt <= 0;
        end
    end
end

// Output signal management
assign shift_ena = (state == SHIFT);
assign counting = (state == COUNT);
assign done = (state == WAIT_ACK);

endmodule