module TopModule(
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

reg [2:0] state;
reg [3:0] delay_reg;
reg [19:0] counter;
reg [3:0] remaining_time;
reg [3:0] pattern_reg;
reg [1:0] shift_count;
reg [3:0] current_delay;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 0;
        delay_reg <= 0;
        counter <= 0;
        remaining_time <= 0;
        pattern_reg <= 0;
        shift_count <= 0;
        current_delay <= 0;
        counting <= 0;
        done <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                pattern_reg <= {pattern_reg[2:0], data};
                if (pattern_reg == 4'b1101) begin
                    state <= 1;
                    pattern_reg <= 0;
                end
            end
            1: begin // SHIFT
                delay_reg <= {data, delay_reg[3:1]};
                shift_count <= shift_count + 1;
                if (shift_count == 4) begin
                    state <= 2;
                    counter <= (delay_reg + 1) * 1000 - 1;
                    current_delay <= delay_reg;
                    remaining_time <= delay_reg;
                    shift_count <= 0;
                end
            end
            2: begin // COUNT
                counting <= 1'b1;
                counter <= counter - 1;
                if (counter == 0) begin
                    state <= 3;
                    counting <= 0;
                end else if (counter % 1000 == 0) begin
                    current_delay <= current_delay - 1;
                    remaining_time <= current_delay;
                end
            end
            3: begin // DONE
                done <= 1'b1;
                if (ack == 1'b1) begin
                    state <= 0;
                    done <= 0;
                    delay_reg <= 0;
                    counter <= 0;
                    remaining_time <= 0;
                    pattern_reg <= 0;
                    shift_count <= 0;
                    current_delay <= 0;
                end
            end
        endcase
    end
end

assign count = remaining_time;

endmodule