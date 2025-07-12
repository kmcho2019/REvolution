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
reg [1:0] shift_cnt;
reg [3:0] pattern;

parameter IDLE = 2'b00;
parameter SHIFT = 2'b01;
parameter COUNT = 2'b10;
parameter WAIT_ACK = 2'b11;

initial begin
    state = IDLE;
    shift_cnt = 0;
    pattern = 0;
    shift_ena = 0;
    counting = 0;
    done = 0;
end

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        shift_cnt <= 0;
        pattern <= 0;
        shift_ena <= 0;
        counting <= 0;
        done <= 0;
    end
    else begin
        case (state)
            IDLE: begin
                pattern <= {pattern[2:0], data};
                if (pattern == 4'b1101) begin
                    pattern <= 0;
                    state <= SHIFT;
                end
            end
            SHIFT: begin
                shift_ena <= 1;
                shift_cnt <= shift_cnt + 1;
                if (shift_cnt == 4) begin
                    shift_ena <= 0;
                    shift_cnt <= 0;
                    state <= COUNT;
                end
            end
            COUNT: begin
                counting <= 1;
                if (done_counting) begin
                    counting <= 0;
                    state <= WAIT_ACK;
                end
            end
            WAIT_ACK: begin
                done <= 1;
                if (ack) begin
                    done <= 0;
                    state <= IDLE;
                end
            end
        endcase
    end
end

endmodule