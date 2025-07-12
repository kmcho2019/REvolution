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
enum logic [2:0] {IDLE, SHIFT, COUNT, DONE} state, next_state;

// Counter for the delay
logic [3:0] delay;

// Counter for the remaining time
logic [3:0] remaining_time;

// Counter for the clock cycles
logic [9:0] cycle_counter;

// Shift register for the input pattern
logic [3:0] shift_register;

always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        delay <= 0;
        remaining_time <= 0;
        cycle_counter <= 0;
        shift_register <= 0;
        count <= 0;
        counting <= 0;
        done <= 0;
    end else begin
        state <= next_state;
        case (state)
            IDLE: begin
                if (shift_register == 4'b1101) begin
                    next_state <= SHIFT;
                end else if (data) begin
                    shift_register <= {shift_register[2:0], data};
                end else begin
                    shift_register <= {shift_register[2:0], 1'b0};
                end
            end
            SHIFT: begin
                if (cycle_counter == 4) begin
                    next_state <= COUNT;
                end else begin
                    delay <= {delay[2:0], data};
                    cycle_counter <= cycle_counter + 1;
                end
            end
            COUNT: begin
                if (remaining_time == 0 && cycle_counter == 0) begin
                    next_state <= DONE;
                end else if (cycle_counter == 1000) begin
                    cycle_counter <= 0;
                    remaining_time <= remaining_time - 1;
                end else begin
                    cycle_counter <= cycle_counter + 1;
                end
            end
            DONE: begin
                if (ack) begin
                    next_state <= IDLE;
                end
            end
        endcase
        case (state)
            IDLE: begin
                counting <= 0;
                count <= 0;
                done <= 0;
            end
            SHIFT: begin
                counting <= 0;
                count <= 0;
                done <= 0;
            end
            COUNT: begin
                counting <= 1;
                count <= remaining_time;
                done <= 0;
            end
            DONE: begin
                counting <= 0;
                count <= 0;
                done <= 1;
            end
        endcase
    end
end

endmodule