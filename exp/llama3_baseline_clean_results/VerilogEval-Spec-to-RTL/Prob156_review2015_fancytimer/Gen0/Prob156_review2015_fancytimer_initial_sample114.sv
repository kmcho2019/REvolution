module TopModule(
    input  clk,
    input  reset,
    input  data,
    output [3:0] count,
    output counting,
    output done,
    input  ack
);

// State machine states
enum logic [2:0] {
    IDLE,
    SHIFT,
    COUNT,
    DONE
} state, next_state;

// Shift register to store the start pattern and delay value
logic [3:0] shift_reg;

// Counter to count the clock cycles
logic [9:0] counter;

// Counter to output the remaining time
logic [3:0] remaining_time;

// Flag to indicate if the start pattern has been detected
logic start_detected;

// Flag to indicate if the delay value has been shifted in
logic delay_shifted;

assign counting = (state == COUNT);
assign done = (state == DONE);

always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        shift_reg <= 4'b0;
        counter <= 10'b0;
        remaining_time <= 4'b0;
        start_detected <= 1'b0;
        delay_shifted <= 1'b0;
    end else begin
        state <= next_state;
        if (next_state == SHIFT) begin
            shift_reg <= {data, shift_reg[3:1]};
        end
        if (next_state == COUNT) begin
            if (counter == 10'b0) begin
                remaining_time <= shift_reg;
            end
            counter <= counter + 1'b1;
            if (counter == 10'b1000) begin
                counter <= 10'b0;
                remaining_time <= remaining_time - 1'b1;
            end
        end
        if (next_state == DONE) begin
            if (ack) begin
                state <= IDLE;
            end
        end
    end
end

always_comb begin
    next_state = state;
    case (state)
        IDLE: begin
            if (data == 1'b1) begin
                shift_reg <= {data, shift_reg[3:1]};
                if (shift_reg == 4'b1101) begin
                    start_detected <= 1'b1;
                    next_state = SHIFT;
                end else begin
                    shift_reg <= 4'b0;
                end
            end else begin
                shift_reg <= 4'b0;
            end
        end
        SHIFT: begin
            if (shift_reg == 4'b1101) begin
                shift_reg <= {data, shift_reg[3:1]};
                if (shift_reg[0] == 1'b1) begin
                    delay_shifted <= 1'b1;
                end
            end else begin
                shift_reg <= 4'b0;
                next_state = IDLE;
            end
            if (delay_shifted) begin
                next_state = COUNT;
            end
        end
        COUNT: begin
            if (remaining_time == 4'b0 && counter == 10'b0) begin
                next_state = DONE;
            end
        end
        DONE: begin
            if (ack) begin
                next_state = IDLE;
            end
        end
    endcase
end

assign count = (state == COUNT) ? remaining_time : 4'bxxxx;

endmodule