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

reg [2:0] state;
reg [3:0] pattern;
reg [1:0] shift_cnt;

parameter IDLE = 3'b000;
parameter SHIFT = 3'b001;
parameter COUNT = 3'b010;
parameter DONE_ACK = 3'b100;

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
                else begin
                    shift_ena <= 0;
                end
            end
            SHIFT: begin
                shift_cnt <= shift_cnt + 1;
                shift_ena <= (shift_cnt < 4);
                if (shift_cnt == 4) begin
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