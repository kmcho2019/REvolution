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

reg [3:0] pattern;
reg [1:0] shift_cnt;
reg [1:0] state;

parameter IDLE = 2'b00;
parameter SHIFT = 2'b01;
parameter COUNT = 2'b10;
parameter DONE_ACK = 2'b11;

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
                    shift_cnt <= 0;
                    shift_ena <= 1;
                end
            end
            SHIFT: begin
                shift_cnt <= shift_cnt + 1;
                if (shift_cnt < 4) begin
                    shift_ena <= 1;
                end
                else begin
                    shift_ena <= 0;
                    state <= COUNT;
                end
            end
            COUNT: begin
                counting <= 1;
                if (done_counting) begin
                    state <= DONE_ACK;
                    counting <= 0;
                    done <= 1;
                end
            end
            DONE_ACK: begin
                if (ack) begin
                    state <= IDLE;
                    done <= 0;
                end
            end
        endcase
    end
end

endmodule