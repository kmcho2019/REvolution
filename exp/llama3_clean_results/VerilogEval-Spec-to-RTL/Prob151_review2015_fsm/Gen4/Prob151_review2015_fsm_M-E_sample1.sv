module TopModule (
    input clk,
    input reset,
    input data,
    input done_counting,
    input ack,
    output reg shift_ena,
    output reg counting,
    output reg done
);

reg [1:0] state;
parameter IDLE = 2'b00;
parameter SHIFT = 2'b01;
parameter COUNT = 2'b10;
parameter WAIT_ACK = 2'b11;

reg [3:0] shift_count;
reg [3:0] pattern;
reg pattern_detected;
reg shift_complete;
reg count_complete;
reg ack_received;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        shift_count <= 0;
        pattern_detected <= 0;
        shift_complete <= 0;
        count_complete <= 0;
        ack_received <= 0;
    end
    else begin
        case (state)
            IDLE: begin
                if (pattern == 4'b1101) begin
                    pattern_detected <= 1;
                    state <= SHIFT;
                end
            end
            SHIFT: begin
                if (shift_count == 4) begin
                    shift_complete <= 1;
                    state <= COUNT;
                end
                else begin
                    shift_count <= shift_count + 1;
                end
            end
            COUNT: begin
                if (done_counting) begin
                    count_complete <= 1;
                    state <= WAIT_ACK;
                end
            end
            WAIT_ACK: begin
                if (ack) begin
                    ack_received <= 1;
                    state <= IDLE;
                end
            end
            default: begin
                state <= IDLE;
            end
        endcase
    end
end

always @(posedge clk) begin
    if (reset) begin
        pattern <= 0;
    end
    else begin
        pattern <= {data, pattern[3:1]};
    end
end

always @(posedge clk) begin
    if (reset) begin
        shift_ena <= 0;
    end
    else if (state == SHIFT) begin
        shift_ena <= 1;
    end
    else begin
        shift_ena <= 0;
    end
end

always @(posedge clk) begin
    if (reset) begin
        counting <= 0;
    end
    else if (state == COUNT) begin
        counting <= 1;
    end
    else begin
        counting <= 0;
    end
end

always @(posedge clk) begin
    if (reset) begin
        done <= 0;
    end
    else if (state == WAIT_ACK) begin
        done <= 1;
    end
    else begin
        done <= 0;
    end
end

endmodule