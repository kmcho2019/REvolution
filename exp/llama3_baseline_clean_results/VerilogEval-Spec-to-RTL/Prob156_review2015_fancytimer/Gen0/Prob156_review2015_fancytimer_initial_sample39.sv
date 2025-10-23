module TopModule (
    input clk,
    input reset,
    input data,
    output [3:0] count,
    output counting,
    output done,
    input ack
);

reg [3:0] state; // 0: IDLE, 1: SHIFT, 2: COUNTING, 3: DONE
reg [3:0] delay; // delay value
reg [3:0] remaining_time; // remaining time
reg [9:0] counter; // counter for 1000 clock cycles
reg [3:0] pattern; // input pattern
reg [2:0] shift_counter; // counter for shifting in 4 bits

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // IDLE
        delay <= 0;
        remaining_time <= 0;
        counter <= 0;
        pattern <= 0;
        shift_counter <= 0;
        done <= 0;
        counting <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                pattern <= {pattern[2:0], data};
                if (pattern == 4'b1101) begin
                    state <= 1; // SHIFT
                    shift_counter <= 3;
                end
            end
            1: begin // SHIFT
                delay <= {delay[2:0], data};
                if (shift_counter == 0) begin
                    state <= 2; // COUNTING
                    remaining_time <= delay;
                    counter <= 0;
                    counting <= 1;
                end else begin
                    shift_counter <= shift_counter - 1;
                end
            end
            2: begin // COUNTING
                counter <= counter + 1;
                if (counter == 1000) begin
                    counter <= 0;
                    if (remaining_time > 0) begin
                        remaining_time <= remaining_time - 1;
                    end else begin
                        state <= 3; // DONE
                        done <= 1;
                        counting <= 0;
                    end
                end
            end
            3: begin // DONE
                if (ack) begin
                    state <= 0; // IDLE
                    done <= 0;
                end
            end
        endcase
    end
end

assign count = (state == 2) ? remaining_time : 4'bxxxx;

endmodule