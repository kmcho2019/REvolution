module TopModule(
    input clk,
    input reset,
    input data,
    output [3:0] count,
    output counting,
    output done,
    input ack
);

reg [3:0] delay;
reg [3:0] current_count;
reg [9:0] remaining_time;
reg [3:0] pattern;
reg counting_reg;
reg done_reg;
reg [1:0] state;
reg [1:0] next_state;

always @(*) begin
    case(state)
        2'b00: begin // Idle state
            if (pattern == 4'b1101) begin
                next_state = 2'b01;
            end else if (reset) begin
                next_state = 2'b00;
            end else begin
                next_state = 2'b00;
            end
        end
        2'b01: begin // Shift state
            if (pattern == 4'b1101) begin
                next_state = 2'b01;
            end else if (pattern == 4'b0000) begin
                next_state = 2'b10;
            end else begin
                next_state = 2'b01;
            end
        end
        2'b10: begin // Count state
            if (remaining_time == 0) begin
                next_state = 2'b11;
            end else begin
                next_state = 2'b10;
            end
        end
        2'b11: begin // Done state
            if (ack) begin
                next_state = 2'b00;
            end else begin
                next_state = 2'b11;
            end
        end
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00;
        pattern <= 4'b0000;
        delay <= 4'b0000;
        current_count <= 4'b0000;
        remaining_time <= 10'b0000000000;
        counting_reg <= 1'b0;
        done_reg <= 1'b0;
    end else begin
        case(state)
            2'b00: begin // Idle state
                pattern[3] <= pattern[2];
                pattern[2] <= pattern[1];
                pattern[1] <= pattern[0];
                pattern[0] <= data;
                if (pattern == 4'b1101) begin
                    state <= 2'b01;
                end
            end
            2'b01: begin // Shift state
                pattern[3] <= pattern[2];
                pattern[2] <= pattern[1];
                pattern[1] <= pattern[0];
                pattern[0] <= data;
                if (pattern == 4'b0000) begin
                    state <= 2'b10;
                    delay <= {data, pattern[3:1]};
                    remaining_time <= (delay + 1) * 10'b100;
                    counting_reg <= 1'b1;
                end
            end
            2'b10: begin // Count state
                if (remaining_time > 0) begin
                    remaining_time <= remaining_time - 1;
                    if (remaining_time[0] == 1'b0) begin
                        current_count <= current_count - 1;
                    end
                end else begin
                    state <= 2'b11;
                    counting_reg <= 1'b0;
                    done_reg <= 1'b1;
                end
            end
            2'b11: begin // Done state
                if (ack) begin
                    state <= 2'b00;
                    done_reg <= 1'b0;
                    current_count <= 4'b0000;
                end
            end
        endcase
    end
end

assign count = current_count;
assign counting = counting_reg;
assign done = done_reg;

endmodule