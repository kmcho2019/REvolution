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

parameter IDLE = 4'b0000;
parameter SHIFT = 4'b0001;
parameter COUNT = 4'b0010;
parameter WAIT_ACK = 4'b0011;

// Combinational logic for next state and output signals
always @(*) begin
    case (state)
        IDLE: begin
            if (pattern == 4'b1101) begin
                shift_ena = 1;
                counting = 0;
                done = 0;
            end
            else begin
                shift_ena = 0;
                counting = 0;
                done = 0;
            end
        end
        SHIFT: begin
            shift_ena = (shift_cnt < 4)? 1 : 0;
            counting = 0;
            done = 0;
        end
        COUNT: begin
            shift_ena = 0;
            counting = 1;
            done = 0;
        end
        WAIT_ACK: begin
            shift_ena = 0;
            counting = 0;
            done = 1;
        end
    endcase
end

// Sequential logic for state register update
always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        pattern <= 0;
        shift_cnt <= 0;
    end
    else begin
        case (state)
            IDLE: begin
                pattern <= {pattern[2:0], data};
                if (pattern == 4'b1101) begin
                    state <= SHIFT;
                    shift_cnt <= 1;
                end
            end
            SHIFT: begin
                if (shift_cnt < 4) begin
                    shift_cnt <= shift_cnt + 1;
                end
                else begin
                    state <= COUNT;
                    shift_cnt <= 0;
                end
            end
            COUNT: begin
                if (done_counting) begin
                    state <= WAIT_ACK;
                end
            end
            WAIT_ACK: begin
                if (ack) begin
                    state <= IDLE;
                    pattern <= 0;
                end
            end
        endcase
    end
end

endmodule