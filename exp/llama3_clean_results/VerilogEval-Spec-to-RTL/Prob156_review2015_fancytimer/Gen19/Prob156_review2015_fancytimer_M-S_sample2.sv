module TopModule(
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

reg [3:0] state; // 0: Idle, 1: Detecting Pattern, 2: Getting Delay, 3: Counting, 4: Done
reg [19:0] counter;
reg [3:0] remaining_time;
reg [3:0] delay;
reg [3:0] shift_reg;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 0;
        counter <= 0;
        remaining_time <= 0;
        counting <= 0;
        done <= 0;
        shift_reg <= 0;
    end else begin
        case(state)
            0: begin // Idle
                if (data == 1) begin
                    shift_reg <= {shift_reg[2:0], data};
                    if (shift_reg == 4'b1101) begin
                        state <= 1;
                    end else begin
                        shift_reg <= {shift_reg[2:0], data};
                    end
                end
            end
            1: begin // Detecting Pattern
                if (shift_reg == 4'b1101) begin
                    state <= 2;
                end
            end
            2: begin // Getting Delay
                shift_reg <= {shift_reg[2:0], data};
                if (shift_reg[0] == 1) begin
                    delay <= {data, delay[3:1]};
                    state <= 3;
                end
            end
            3: begin // Counting
                if (counter == 0) begin
                    counter <= (delay + 1) * 1000 - 1;
                    remaining_time <= delay;
                end else begin
                    counter <= counter - 1;
                    if (counter % 1000 == 0) begin
                        remaining_time <= remaining_time - 1;
                    end
                    if (counter == 0) begin
                        state <= 4;
                    end
                end
                counting <= 1;
            end
            4: begin // Done
                done <= 1;
                if (ack == 1'b1) begin
                    state <= 0;
                    done <= 0;
                end
            end
        endcase
    end
end

assign count = remaining_time;

endmodule