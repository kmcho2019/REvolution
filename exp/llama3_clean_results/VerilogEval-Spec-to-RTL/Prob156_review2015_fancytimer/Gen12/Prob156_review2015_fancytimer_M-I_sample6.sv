module TopModule (
    input clk,
    input reset,
    input data,
    output logic [3:0] count,
    output logic counting,
    output logic done,
    input ack
);

logic [1:0] state, next_state;
logic [3:0] delay;
logic [9:0] remaining_time;
logic [3:0] pattern;
logic shift_done;
logic [3:0] shift_counter;

always_ff @ (posedge clk) begin
    if (reset) begin
        state <= 2'b00;
        delay <= 0;
        remaining_time <= 0;
        pattern <= 0;
        shift_done <= 0;
        shift_counter <= 0;
    end else begin
        case (state)
            2'b00: begin // IDLE
                if (data == 1'b1) begin
                    pattern <= {pattern[2:0], data};
                    if (pattern == 4'b1101) begin
                        next_state <= 2'b01;
                    end else begin
                        next_state <= 2'b00;
                    end
                end else begin
                    next_state <= 2'b00;
                end
            end
            2'b01: begin // SHIFT
                shift_counter <= shift_counter + 1;
                delay <= {data, delay[2:0]};
                if (shift_counter == 4) begin
                    shift_done <= 1;
                    next_state <= 2'b10;
                    remaining_time <= (delay + 1) * 1000 - 1;
                end else begin
                    next_state <= 2'b01;
                end
            end
            2'b10: begin // COUNT
                remaining_time <= remaining_time - 1;
                if (remaining_time == 0) begin
                    next_state <= 2'b11;
                end else begin
                    next_state <= 2'b10;
                end
            end
            2'b11: begin // DONE
                if (ack) begin
                    next_state <= 2'b00;
                end else begin
                    next_state <= 2'b11;
                end
            end
            default: next_state <= 2'b00;
        endcase
        state <= next_state;
    end
end

always_comb begin
    counting = (state == 2'b10);
    done = (state == 2'b11);
    if (state == 2'b10) begin
        count = delay - ((1000 - (remaining_time % 1000)) / 1000);
    end else begin
        count = 0;
    end
end

endmodule