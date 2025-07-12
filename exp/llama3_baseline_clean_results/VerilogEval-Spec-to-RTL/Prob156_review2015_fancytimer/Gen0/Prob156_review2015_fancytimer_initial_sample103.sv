module TopModule(
    input clk,
    input reset,
    input data,
    output [3:0] count,
    output counting,
    output done,
    input ack
);

reg [3:0] state; // 0: IDLE, 1: SHIFT, 2: COUNT, 3: DONE
reg [3:0] shift_reg; // holds the input pattern
reg [3:0] delay; // holds the duration
reg [3:0] counter; // holds the current count
reg [9:0] timer; // holds the timer value

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // IDLE
        shift_reg <= 0;
        delay <= 0;
        counter <= 0;
        timer <= 0;
        counting <= 0;
        done <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                shift_reg <= {data, shift_reg[3:1]};
                if (shift_reg == 4'b1101) begin
                    state <= 1; // SHIFT
                end
            end
            1: begin // SHIFT
                delay[3:0] <= {data, delay[3:1]};
                if (delay[0] != 1'bx) begin
                    state <= 2; // COUNT
                    counter <= delay + 1;
                    timer <= 1000;
                    counting <= 1;
                end else begin
                    delay[3:0] <= {data, delay[3:1]};
                end
            end
            2: begin // COUNT
                if (timer == 0) begin
                    if (counter == 1) begin
                        state <= 3; // DONE
                        counting <= 0;
                        done <= 1;
                    end else begin
                        counter <= counter - 1;
                        timer <= 1000;
                    end
                end else begin
                    timer <= timer - 1;
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

always @(*) begin
    case (state)
        0, 1: count = 4'bx;
        2: count = counter - 1;
        3: count = 4'bx;
    endcase
end

endmodule