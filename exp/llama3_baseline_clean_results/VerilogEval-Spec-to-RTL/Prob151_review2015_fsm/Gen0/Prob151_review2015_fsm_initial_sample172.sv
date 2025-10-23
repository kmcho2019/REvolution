module TopModule(
    input clk,
    input reset,
    input data,
    input done_counting,
    input ack,
    output shift_ena,
    output counting,
    output done
);

// State encoding
parameter IDLE = 2'b00;
parameter SHIFT = 2'b01;
parameter COUNTING = 2'b10;
parameter DONE = 2'b11;

reg [1:0] state, next_state;
reg [3:0] pattern_detector; // To detect the 1101 pattern
reg [1:0] shift_counter; // Counter for shift operation

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        pattern_detector <= 4'b0000;
        shift_counter <= 2'b00;
    end else begin
        state <= next_state;
        pattern_detector <= {data, pattern_detector[3:1]};
        if (state == SHIFT) begin
            shift_counter <= shift_counter + 1;
        end else begin
            shift_counter <= 2'b00;
        end
    end
end

always @(*) begin
    case(state)
        IDLE: begin
            if (pattern_detector == 4'b1101) begin
                next_state = SHIFT;
            end else begin
                next_state = IDLE;
            end
        end
        SHIFT: begin
            if (shift_counter == 2'b11) begin // After 4 cycles (since it's 0-based)
                next_state = COUNTING;
            end else begin
                next_state = SHIFT;
            end
        end
        COUNTING: begin
            if (done_counting) begin
                next_state = DONE;
            end else begin
                next_state = COUNTING;
            end
        end
        DONE: begin
            if (ack) begin
                next_state = IDLE;
            end else begin
                next_state = DONE;
            end
        end
        default: next_state = IDLE;
    endcase
end

assign shift_ena = (state == SHIFT);
assign counting = (state == COUNTING);
assign done = (state == DONE);

endmodule