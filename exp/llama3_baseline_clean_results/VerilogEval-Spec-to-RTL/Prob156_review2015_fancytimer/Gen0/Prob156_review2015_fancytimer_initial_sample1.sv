module TopModule(
    input clk,
    input reset,
    input data,
    output [3:0] count,
    output counting,
    output done,
    input ack
);

// State machine states
enum logic [2:0] {
    IDLE,
    SHIFT,
    COUNTING,
    DONE
} state, next_state;

// Shift register for input pattern detection
logic [3:0] shift_reg;

// Counter for counting phase
logic [9:0] counter;

// Delay value
logic [3:0] delay;

// Current remaining time
logic [3:0] remaining_time;

// State machine
always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        shift_reg <= 0;
        counter <= 0;
        delay <= 0;
        remaining_time <= 0;
        count <= 0;
        counting <= 0;
        done <= 0;
    end else begin
        case (state)
            IDLE: begin
                shift_reg <= {shift_reg[2:0], data};
                if (shift_reg == 4'b1101) begin
                    state <= SHIFT;
                    shift_reg <= 0;
                end
            end
            SHIFT: begin
                shift_reg <= {shift_reg[2:0], data};
                if (shift_reg[0] == 1'b0) begin // most significant bit
                    delay <= shift_reg[3:0];
                    state <= COUNTING;
                    counter <= 0;
                    remaining_time <= delay;
                    counting <= 1;
                end
            end
            COUNTING: begin
                counter <= counter + 1;
                if (counter == 1000) begin
                    remaining_time <= remaining_time - 1;
                    counter <= 0;
                    if (remaining_time == 0) begin
                        state <= DONE;
                        counting <= 0;
                        done <= 1;
                    end
                end
            end
            DONE: begin
                if (ack) begin
                    state <= IDLE;
                    done <= 0;
                end
            end
        endcase
        count <= remaining_time;
    end
end

endmodule