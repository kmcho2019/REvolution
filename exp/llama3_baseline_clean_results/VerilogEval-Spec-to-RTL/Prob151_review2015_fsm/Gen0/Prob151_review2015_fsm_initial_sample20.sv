module TopModule(
    input clk,
    input reset,
    input data,
    input done_counting,
    input ack,
    output shift_ena,
    output counting,
    output done
);

reg [1:0] state; // IDLE, SHIFT, COUNT, DONE
reg [3:0] shift_cnt; // counter for 4 clock cycles

parameter IDLE = 2'b00;
parameter SHIFT = 2'b01;
parameter COUNT = 2'b10;
parameter DONE_WAIT = 2'b11;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        shift_cnt <= 4'b0000;
    end else begin
        case (state)
            IDLE: begin
                // Check for pattern 1101
                if (data == 1'b1 && shift_cnt == 4'b1101) begin
                    state <= SHIFT;
                    shift_cnt <= 4'b0000;
                end else if (data == 1'b1) begin
                    shift_cnt <= {shift_cnt[2:0], 1'b1};
                end else begin
                    shift_cnt <= {shift_cnt[2:0], 1'b0};
                end
            end
            SHIFT: begin
                if (shift_cnt == 4'b1000) begin
                    state <= COUNT;
                end else begin
                    shift_cnt <= shift_cnt + 1'b1;
                end
            end
            COUNT: begin
                if (done_counting) begin
                    state <= DONE_WAIT;
                end
            end
            DONE_WAIT: begin
                if (ack) begin
                    state <= IDLE;
                end
            end
            default: state <= IDLE;
        endcase
    end
end

always @(*) begin
    case (state)
        IDLE: begin
            shift_ena = 1'b0;
            counting = 1'b0;
            done = 1'b0;
        end
        SHIFT: begin
            shift_ena = 1'b1;
            counting = 1'b0;
            done = 1'b0;
        end
        COUNT: begin
            shift_ena = 1'b0;
            counting = 1'b1;
            done = 1'b0;
        end
        DONE_WAIT: begin
            shift_ena = 1'b0;
            counting = 1'b0;
            done = 1'b1;
        end
        default: begin
            shift_ena = 1'b0;
            counting = 1'b0;
            done = 1'b0;
        end
    endcase
end

endmodule