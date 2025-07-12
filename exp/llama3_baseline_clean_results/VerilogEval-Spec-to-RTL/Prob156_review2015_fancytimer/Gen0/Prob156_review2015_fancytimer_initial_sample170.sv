module TopModule(
    input           clk,
    input           reset,
    input           data,
    output  [3:0]   count,
    output          counting,
    output          done,
    input           ack
);

reg [3:0]          state;
reg [3:0]          delay;
reg [3:0]          remaining_time;
reg [3:0]          count_out;
reg               counting_out;
reg               done_out;
reg [3:0]          shift_reg;
reg               pattern_detected;

parameter IDLE    = 4'b0000;
parameter SHIFT   = 4'b0001;
parameter COUNT   = 4'b0010;
parameter DONE    = 4'b0011;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;
        delay <= 4'b0000;
        remaining_time <= 4'b0000;
        count_out <= 4'b0000;
        counting_out <= 1'b0;
        done_out <= 1'b0;
        shift_reg <= 4'b0000;
        pattern_detected <= 1'b0;
    end
    else begin
        case (state)
            IDLE: begin
                if (pattern_detected) begin
                    state <= SHIFT;
                    shift_reg <= 4'b0000;
                end
                else if (data) begin
                    shift_reg <= {shift_reg[2:0], 1'b1};
                    if (shift_reg == 4'b1101) begin
                        pattern_detected <= 1'b1;
                    end
                    else begin
                        shift_reg <= 4'b0000;
                        pattern_detected <= 1'b0;
                    end
                end
                else begin
                    shift_reg <= {shift_reg[2:0], 1'b0};
                    if (shift_reg == 4'b1101) begin
                        pattern_detected <= 1'b1;
                    end
                    else begin
                        shift_reg <= 4'b0000;
                        pattern_detected <= 1'b0;
                    end
                end
            end
            SHIFT: begin
                shift_reg <= {shift_reg[2:0], data};
                if (shift_reg[3]) begin
                    delay <= shift_reg;
                    state <= COUNT;
                    remaining_time <= delay + 1;
                    count_out <= delay;
                    counting_out <= 1'b1;
                end
            end
            COUNT: begin
                if (remaining_time > 1) begin
                    if (count_out > 0) begin
                        count_out <= count_out - 1;
                    end
                    else begin
                        remaining_time <= remaining_time - 1;
                        count_out <= remaining_time;
                    end
                end
                else begin
                    state <= DONE;
                    done_out <= 1'b1;
                    counting_out <= 1'b0;
                end
            end
            DONE: begin
                if (ack) begin
                    state <= IDLE;
                    done_out <= 1'b0;
                    pattern_detected <= 1'b0;
                    shift_reg <= 4'b0000;
                end
            end
        endcase
    end
end

assign count = count_out;
assign counting = counting_out;
assign done = done_out;

endmodule