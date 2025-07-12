module TopModule (
    input clk,
    input reset,
    input data,
    output logic [3:0] count,
    output logic counting,
    output logic done,
    input ack
);

logic [1:0] state;
logic [3:0] delay;
logic [9:0] remaining_time;
logic [3:0] pattern;
logic [3:0] shift_count;

always_ff @ (posedge clk) begin
    if (reset) begin
        state <= 2'b00;
        delay <= 0;
        remaining_time <= 0;
        pattern <= 0;
        count <= 0;
        shift_count <= 0;
    end else begin
        case (state)
            2'b00: begin // IDLE
                if (data == 1'b1) begin
                    pattern <= {pattern[2:0], data};
                    if (pattern == 4'b1101) begin
                        state <= 2'b01;
                        pattern <= 0;
                    end
                end else if (data == 1'b0) begin
                    pattern <= {pattern[2:0], data};
                end
            end
            2'b01: begin // SHIFT
                if (shift_count < 4) begin
                    delay <= {data, delay[2:0]};
                    shift_count <= shift_count + 1;
                end else begin
                    state <= 2'b10;
                    remaining_time <= (delay + 1) * 1000;
                    shift_count <= 0;
                    count <= delay;
                end
            end
            2'b10: begin // COUNT
                if (remaining_time > 0) begin
                    remaining_time <= remaining_time - 1;
                    if (remaining_time % 1000 == 0) begin
                        count <= count - 1;
                    end
                end else begin
                    done <= 1;
                    if (ack) begin
                        state <= 2'b00;
                        done <= 0;
                    end
                end
            end
            default: state <= 2'b00;
        endcase
    end
end

always_comb begin
    counting = (state == 2'b10);
end

endmodule