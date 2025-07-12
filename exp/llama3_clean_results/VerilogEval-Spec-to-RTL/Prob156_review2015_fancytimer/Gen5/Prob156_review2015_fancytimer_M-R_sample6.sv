module TopModule (
    input clk,
    input reset,
    input data,
    output [3:0] count,
    output counting,
    output done,
    input ack
);

enum logic [1:0] {IDLE, SHIFT, COUNT, DONE} state, next_state;

reg [3:0] delay; // delay value
reg [9:0] remaining_time; // remaining time
reg [3:0] shift_count; // counter for shifting delay
reg [3:0] pattern; // pattern detection

always @ (posedge clk) begin
    if (reset) begin
        state <= IDLE;
        delay <= 0;
        remaining_time <= 0;
        shift_count <= 0;
        pattern <= 0;
    end else begin
        state <= next_state;
        case (state)
            IDLE: begin
                if (data == 1'b1) begin
                    pattern <= {data, pattern[2:0]};
                    if (pattern == 4'b1101) begin
                        next_state <= SHIFT;
                    end else begin
                        next_state <= IDLE;
                    end
                end else begin
                    pattern <= 0;
                    next_state <= IDLE;
                end
            end
            SHIFT: begin
                delay <= {data, delay[2:0]}; // shift in delay value
                shift_count <= shift_count + 1;
                if (shift_count == 4) begin // check if all 4 bits have been shifted
                    next_state <= COUNT;
                end else begin
                    next_state <= SHIFT;
                end
            end
            COUNT: begin
                remaining_time <= remaining_time - 1;
                if (remaining_time == 0) begin
                    next_state <= DONE;
                end else begin
                    next_state <= COUNT;
                end
            end
            DONE: begin
                if (ack) begin // check for acknowledgement
                    next_state <= IDLE;
                end else begin
                    next_state <= DONE;
                end
            end
            default: next_state <= IDLE;
        endcase
    end
end

assign count = (remaining_time > 999)? (remaining_time / 1000) : 0;
assign counting = (state == COUNT);
assign done = (state == DONE);

always @ (posedge clk) begin
    if (reset) begin
        remaining_time <= 0;
    end else if (state == SHIFT && shift_count == 4) begin
        remaining_time <= (delay + 1) * 1000;
    end else if (state == COUNT) begin
        remaining_time <= remaining_time - 1;
    end
end

endmodule