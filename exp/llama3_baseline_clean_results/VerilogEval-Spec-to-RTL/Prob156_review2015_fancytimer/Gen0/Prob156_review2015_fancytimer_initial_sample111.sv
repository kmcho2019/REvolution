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
reg [9:0] counter;
reg [3:0] remaining_time;
reg [3:0] shift_reg;

always @(posedge clk) begin
    if (reset) begin
        counting <= 0;
        done <= 0;
        count <= 0;
        counter <= 0;
        remaining_time <= 0;
        shift_reg <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (data == 1) begin
                    shift_reg[0] <= 1;
                    for (int i = 1; i < 4; i++) begin
                        shift_reg[i] <= shift_reg[i-1];
                    end
                end else if (data == 0) begin
                    shift_reg[0] <= 0;
                    for (int i = 1; i < 4; i++) begin
                        shift_reg[i] <= shift_reg[i-1];
                    end
                end
                if (shift_reg == 4'b1101) begin
                    state <= DELAY_LOADING;
                end
            end
            DELAY_LOADING: begin
                delay[0] <= data;
                for (int i = 1; i < 4; i++) begin
                    delay[i] <= delay[i-1];
                end
                state <= (data == 1'b0 && delay[3:1] == 3'b000) ? COUNTING : DELAY_LOADING;
            end
            COUNTING: begin
                counting <= 1;
                if (counter == 1000) begin
                    counter <= 0;
                    remaining_time <= remaining_time - 1;
                end else begin
                    counter <= counter + 1;
                end
                count <= remaining_time;
                if (remaining_time == 0) begin
                    counting <= 0;
                    state <= DONE;
                end
            end
            DONE: begin
                done <= 1;
                if (ack) begin
                    state <= IDLE;
                end
            end
        endcase
    end
end

reg [1:0] state;
initial state = IDLE;

always @(posedge clk) begin
    if (!reset) begin
        case (state)
            IDLE: begin
                remaining_time <= 0;
            end
            DELAY_LOADING: begin
                remaining_time <= delay;
            end
            COUNTING: begin
                // count for (delay+1)*1000 clock cycles
            end
            DONE: begin
                // wait for ack
            end
        endcase
    end
end

endmodule