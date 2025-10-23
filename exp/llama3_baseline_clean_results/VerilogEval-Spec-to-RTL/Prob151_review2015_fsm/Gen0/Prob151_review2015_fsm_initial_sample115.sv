module TopModule(
    input clk,
    input reset,
    input data,
    input done_counting,
    input ack,
    output reg shift_ena,
    output reg counting,
    output reg done
);

reg [1:0] state, next_state;
reg [2:0] shift_counter, next_shift_counter;
reg [3:0] pattern, next_pattern;

always @(*) begin
    // Default values
    next_state = state;
    next_shift_counter = shift_counter;
    next_pattern = pattern;
    shift_ena = 1'b0;
    counting = 1'b0;
    done = 1'b0;

    case(state)
        2'b00: // Idle
            if (pattern == 4'b1101) begin
                next_state = 2'b01;
                next_shift_counter = 4'b0001;
            end else begin
                next_pattern = {pattern[2:0], data};
            end

        2'b01: // Shift
            shift_ena = 1'b1;
            next_shift_counter = shift_counter - 1'b1;
            if (shift_counter == 1'b0) begin
                next_state = 2'b10;
            end

        2'b10: // Count
            counting = 1'b1;
            if (done_counting) begin
                next_state = 2'b11;
            end

        2'b11: // Done
            done = 1'b1;
            if (ack) begin
                next_state = 2'b00;
            end
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00;
        shift_counter <= 4'b0000;
        pattern <= 4'b0000;
    end else begin
        state <= next_state;
        shift_counter <= next_shift_counter;
        pattern <= next_pattern;
    end
end

endmodule