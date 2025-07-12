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

reg [2:0] state; // Using 3-bit state variable for 4 states
reg [3:0] pattern; // Pattern register to hold the last 4 bits of input data
reg [1:0] shift_cnt; // Counter for shifting

parameter IDLE = 3'b000;
parameter SHIFT = 3'b001;
parameter COUNT = 3'b010;
parameter WAIT_ACK = 3'b100;

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
                // Update pattern register to hold the last 4 bits of input data
                pattern <= {data, pattern[3:1]};
                if (pattern == 4'b1101) begin
                    state <= SHIFT;
                    shift_cnt <= 0; // Initialize shift_cnt to 0
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
                if (done_counting) begin
                    state <= WAIT_ACK;
                    counting <= 0;
                    done <= 1;
                end
            end
            WAIT_ACK: begin
                if (ack) begin
                    state <= IDLE;
                    done <= 0;
                end
            end
        endcase
    end
end

endmodule