module TopModule(
    input  clk,
    input  reset,
    input  data,
    input  done_counting,
    input  ack,
    output shift_ena,
    output counting,
    output done
);

reg [2:0] state, next_state;
reg [3:0] pattern;
reg shift_ena_reg, counting_reg, done_reg;
reg [1:0] shift_counter;

parameter IDLE = 3'b000, PATTERN_RECEIVED = 3'b001, COUNTING = 3'b010, DONE = 3'b011, SHIFT1 = 3'b100, SHIFT2 = 3'b101, SHIFT3 = 3'b110, SHIFT4 = 3'b111;

always @(*) begin
    case (state)
        IDLE: begin
            if (pattern == 4'b1101) next_state = PATTERN_RECEIVED;
            else next_state = IDLE;
        end
        PATTERN_RECEIVED: begin
            next_state = SHIFT1;
        end
        SHIFT1: begin
            next_state = SHIFT2;
        end
        SHIFT2: begin
            next_state = SHIFT3;
        end
        SHIFT3: begin
            next_state = SHIFT4;
        end
        SHIFT4: begin
            next_state = COUNTING;
        end
        COUNTING: begin
            if (done_counting) next_state = DONE;
            else next_state = COUNTING;
        end
        DONE: begin
            if (ack) next_state = IDLE;
            else next_state = DONE;
        end
    endcase
    if (reset) next_state = IDLE;
end

always @(*) begin
    case (state)
        IDLE: begin
            shift_ena_reg = 1'b0;
            counting_reg = 1'b0;
            done_reg = 1'b0;
        end
        PATTERN_RECEIVED, SHIFT1, SHIFT2, SHIFT3, SHIFT4: begin
            shift_ena_reg = 1'b1;
            counting_reg = 1'b0;
            done_reg = 1'b0;
        end
        COUNTING: begin
            shift_ena_reg = 1'b0;
            counting_reg = 1'b1;
            done_reg = 1'b0;
        end
        DONE: begin
            shift_ena_reg = 1'b0;
            counting_reg = 1'b0;
            done_reg = 1'b1;
        end
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        pattern <= 4'b0000;
        shift_counter <= 2'b00;
    end
    else begin
        state <= next_state;
        if (state == IDLE) begin
            pattern <= {pattern[2:0], data};
        end
        else if (state == SHIFT1 || state == SHIFT2 || state == SHIFT3 || state == SHIFT4) begin
            shift_counter <= shift_counter + 1;
        end
        else begin
            shift_counter <= 2'b00;
        end
    end
end

assign shift_ena = shift_ena_reg;
assign counting = counting_reg;
assign done = done_reg;

endmodule