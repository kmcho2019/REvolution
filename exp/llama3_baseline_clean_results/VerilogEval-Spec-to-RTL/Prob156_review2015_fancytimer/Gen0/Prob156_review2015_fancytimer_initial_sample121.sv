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
reg [3:0] remaining_time;
reg [3:0] current_count;
reg [3:0] shift_register;
reg [2:0] state;
reg counting_reg;
reg done_reg;

parameter IDLE = 3'd0;
parameter SHIFT_DELAY = 3'd1;
parameter COUNTING = 3'd2;
parameter DONE = 3'd3;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        delay <= 4'd0;
        remaining_time <= 4'd0;
        current_count <= 4'd0;
        counting_reg <= 1'd0;
        done_reg <= 1'd0;
        shift_register <= 4'd0;
    end else begin
        case (state)
            IDLE: begin
                if (shift_register == 4'd13) begin // 1101 in binary is 13
                    state <= SHIFT_DELAY;
                    shift_register <= 4'd0;
                end else if (data) begin
                    shift_register <= {shift_register[2:0], 1'b1};
                end else begin
                    shift_register <= {shift_register[2:0], 1'b0};
                end
            end
            SHIFT_DELAY: begin
                if (shift_register == 4'd0) begin
                    delay <= current_count;
                    state <= COUNTING;
                    remaining_time <= delay;
                    counting_reg <= 1'd1;
                    current_count <= 4'd0;
                end else begin
                    shift_register <= shift_register - 1;
                    current_count <= {data, current_count[3:1]};
                end
            end
            COUNTING: begin
                if (current_count == 4'd999) begin // 1000 cycles
                    if (remaining_time == 4'd1) begin
                        state <= DONE;
                        counting_reg <= 1'd0;
                    end else begin
                        remaining_time <= remaining_time - 1;
                    end
                    current_count <= 4'd0;
                end else begin
                    current_count <= current_count + 1;
                end
            end
            DONE: begin
                if (ack) begin
                    state <= IDLE;
                    done_reg <= 1'd0;
                end
            end
        endcase
    end
end

always @(*) begin
    count = (state == COUNTING) ? remaining_time : 4'd0;
    counting = counting_reg;
    done = (state == DONE) ? 1'd1 : 1'd0;
end

endmodule