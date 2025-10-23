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

reg [3:0] state;
reg [3:0] pattern;
reg [1:0] shift_cnt;

parameter IDLE = 4'b0001;
parameter SHIFT = 4'b0010;
parameter COUNT = 4'b0100;
parameter WAIT_ACK = 4'b1000;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        pattern <= 0;
        shift_cnt <= 0;
        shift_ena <= 0;
        counting <= 0;
        done <= 0;
    end
    else begin
        case (state)
            IDLE: begin
                pattern <= {pattern[2:0], data};
                if (pattern == 4'b1101) begin
                    state <= SHIFT;
                    shift_cnt <= 1;
                    shift_ena <= 1;
                end
            end
            SHIFT: begin
                if (shift_cnt < 4) begin
                    shift_cnt <= shift_cnt + 1;
                    shift_ena <= 1;
                end
                else begin
                    state <= COUNT;
                    shift_ena <= 0;
                    counting <= 1;
                end
            end
            COUNT: begin
                counting <= 1;
                if (done_counting) begin
                    state <= WAIT_ACK;
                    counting <= 0;
                    done <= 1;
                end
            end
            WAIT_ACK: begin
                done <= 1;
                if (ack) begin
                    state <= IDLE;
                    done <= 0;
                end
            end
        endcase
    end
end

endmodule