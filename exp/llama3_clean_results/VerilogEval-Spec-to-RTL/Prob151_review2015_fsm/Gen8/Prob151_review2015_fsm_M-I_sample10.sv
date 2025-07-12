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

// Main logic
always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        pattern <= 0;
        duration <= 0;
        shift_count <= 0;
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
                    shift_ena <= 1;
                end
                counting <= 0;
                done <= 0;
            end
            SHIFT: begin
                if (shift_count == 4) begin
                    shift_ena <= 0;
                    state <= COUNT;
                end
                else begin
                    duration <= {duration[2:0], data};
                    shift_count <= shift_count + 1;
                end
                counting <= 0;
                done <= 0;
            end
            COUNT: begin
                counting <= 1;
                if (done_counting) begin
                    state <= WAIT_ACK;
                end
                done <= 0;
            end
            WAIT_ACK: begin
                done <= 1;
                if (ack) begin
                    state <= IDLE;
                end
                shift_ena <= 0;
                counting <= 0;
            end
        endcase
    end
end

endmodule