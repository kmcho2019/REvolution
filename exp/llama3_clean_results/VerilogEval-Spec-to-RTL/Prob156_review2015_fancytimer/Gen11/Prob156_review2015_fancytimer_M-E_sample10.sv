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

// Counter module
logic [9:0] counter_out;
logic counter_enable;

always_ff @ (posedge clk) begin
    if (reset) begin
        counter_out <= 0;
    end else if (counter_enable) begin
        counter_out <= counter_out - 1;
    end
end

always_comb begin
    if (counter_out == 0) begin
        counter_enable = 0;
    end else begin
        counter_enable = (state == 2'b10);
    end
end

// FSM
always_ff @ (posedge clk) begin
    if (reset) begin
        state <= 2'b00;
        delay <= 0;
        remaining_time <= 0;
        pattern <= 0;
        count <= 0;
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
                delay <= {data, delay[2:0]};
                if (delay[0] == 1'b1) begin
                    next_state <= 2'b10;
                    remaining_time <= (delay + 1) * 1000;
                end else begin
                    next_state <= 2'b01;
                end
            end
            2'b10: begin // COUNT
                if (counter_out == 0) begin
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
        count = delay - (remaining_time / 1000);
    end else begin
        count = 0;
    end
end

endmodule