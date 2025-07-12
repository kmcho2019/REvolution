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

// Define states
reg [2:0] state;
parameter IDLE = 3'b000;
parameter PATTERN_DETECT = 3'b001;
parameter SHIFT = 3'b010;
parameter COUNT = 3'b011;
parameter WAIT_ACK = 3'b100;

// Define registers
reg [3:0] pattern;
reg [3:0] duration;
reg [1:0] shift_count;

// Initialize signals
initial begin
    state = IDLE;
    pattern = 0;
    duration = 0;
    shift_count = 0;
    shift_ena = 0;
    counting = 0;
    done = 0;
end

// Next state logic
always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        pattern <= 0;
        duration <= 0;
        shift_count <= 0;
    end
    else begin
        case (state)
            IDLE: begin
                if (data == 1'b1) begin
                    pattern <= {pattern[2:0], 1'b1};
                    if (pattern == 4'b1101) begin
                        state <= PATTERN_DETECT;
                    end
                end
                else begin
                    pattern <= {pattern[2:0], 1'b0};
                end
            end
            PATTERN_DETECT: begin
                state <= SHIFT;
            end
            SHIFT: begin
                if (shift_count == 4) begin
                    state <= COUNT;
                end
                else begin
                    shift_count <= shift_count + 1;
                    duration <= {duration[2:0], data};
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
                end
            end
        endcase

        // Output logic
        shift_ena <= (state == SHIFT);
        counting <= (state == COUNT);
        done <= (state == WAIT_ACK);
    end
end

endmodule