module TopModule (
    input  clk,
    input  reset,
    input  data,
    output [3:0] count,
    output counting,
    output done,
    input  ack
);

// Define the states of the FSM
enum logic [2:0] {
    IDLE,
    SHIFT,
    COUNT,
    DONE
} state, next_state;

// Define the variables to keep track of the delay and the remaining time
logic [3:0] delay;
logic [3:0] remaining_time;
logic [9:0] clock_counter;

// Define the shift register to detect the input pattern
logic [3:0] shift_register;

always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        shift_register <= 4'b0000;
        delay <= 4'b0000;
        remaining_time <= 4'b0000;
        clock_counter <= 10'b0000000000;
        count <= 4'b0000;
        counting <= 1'b0;
        done <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                shift_register <= {data, shift_register[3:1]};
                if (shift_register == 4'b1101) begin
                    state <= SHIFT;
                end else begin
                    state <= IDLE;
                end
            end
            SHIFT: begin
                if (clock_counter == 10'b1000000000) begin
                    state <= COUNT;
                    clock_counter <= 10'b0000000000;
                    remaining_time <= delay;
                    counting <= 1'b1;
                end else begin
                    delay <= {data, delay[3:1]};
                    clock_counter <= clock_counter + 1;
                    state <= SHIFT;
                end
            end
            COUNT: begin
                if (clock_counter == 10'b1000000000) begin
                    if (remaining_time == 4'b0000) begin
                        state <= DONE;
                        counting <= 1'b0;
                        clock_counter <= 10'b0000000000;
                    end else begin
                        remaining_time <= remaining_time - 1;
                        clock_counter <= 10'b0000000000;
                    end
                end else begin
                    clock_counter <= clock_counter + 1;
                    count <= remaining_time;
                    state <= COUNT;
                end
            end
            DONE: begin
                if (ack) begin
                    state <= IDLE;
                    done <= 1'b0;
                end else begin
                    state <= DONE;
                end
            end
            default: state <= IDLE;
        endcase;
    end
end

assign done = (state == DONE)? 1'b1 : 1'b0;

endmodule