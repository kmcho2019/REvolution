module TopModule(
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

reg [3:0] delay;
reg [3:0] counter;
reg [9:0] timer;
reg [3:0] shift_counter;
reg [3:0] state_counter;
reg [3:0] id;

always @(posedge clk) begin
    if (reset) begin
        // Reset the FSM to the IDLE state
        id <= 0;
        counting <= 0;
        done <= 0;
        count <= 0;
        counter <= 0;
        timer <= 0;
        shift_counter <= 0;
        state_counter <= 0;
    end else begin
        case (id)
            // Searching for the input pattern 1101
            0: begin
                if (data) begin
                    state_counter <= state_counter + 1;
                    if (state_counter == 4'b0001) begin
                        id <= 1;
                        state_counter <= 0;
                    end
                end else begin
                    state_counter <= 0;
                end
            end
            // Shift in 4 more bits to determine the duration of the timer delay
            1: begin
                shift_counter <= shift_counter + 1;
                delay[3] <= data;
                delay[2] <= (shift_counter == 1) ? data : delay[2];
                delay[1] <= (shift_counter == 2) ? data : delay[1];
                delay[0] <= (shift_counter == 3) ? data : delay[0];
                if (shift_counter == 4) begin
                    id <= 2;
                    shift_counter <= 0;
                    counter <= delay + 1;
                    timer <= 0;
                    counting <= 1;
                end
            end
            // Count for exactly (delay[3:0] + 1) * 1000 clock cycles
            2: begin
                timer <= timer + 1;
                count <= counter - 1;
                if (timer == 1000) begin
                    counter <= counter - 1;
                    timer <= 0;
                    if (counter == 0) begin
                        id <= 3;
                        counting <= 0;
                        done <= 1;
                    end
                end
            end
            // Assert done to notify the user the timer has timed out and wait until input ack is 1
            3: begin
                if (ack) begin
                    id <= 0;
                    done <= 0;
                end
            end
        endcase
    end
end

endmodule