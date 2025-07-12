module TopModule (
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

reg [3:0] delay;
reg [3:0] counter;
reg [3:0] pattern_detector;
reg [9:0] timer_counter;

always @(posedge clk) begin
    if (reset) begin
        // Reset the FSM to the IDLE state
        pattern_detector <= 0;
        count <= 0;
        counting <= 0;
        done <= 0;
        timer_counter <= 0;
    end else begin
        case (pattern_detector)
            4'b0000: begin
                // IDLE state: searching for the pattern '1101'
                if (data) begin
                    pattern_detector <= {pattern_detector[2:0], 1'b1};
                end else begin
                    pattern_detector <= {pattern_detector[2:0], 1'b0};
                end
                if (pattern_detector == 4'b1101) begin
                    pattern_detector <= 4'b1000; // Transition to SHIFT_DELAY state
                end
            end
            4'b1000: begin
                // SHIFT_DELAY state: shifting in the 4-bit delay
                delay <= {delay[2:0], data};
                pattern_detector <= pattern_detector + 1;
                if (pattern_detector == 4'b1001) begin
                    pattern_detector <= 0; // Transition to COUNTING state
                    timer_counter <= (delay + 1) * 1000 - 1;
                    counting <= 1;
                end
            end
            0: begin
                // COUNTING state: counting down the timer
                if (timer_counter == 0) begin
                    counting <= 0;
                    done <= 1;
                end else begin
                    timer_counter <= timer_counter - 1;
                    count <= (timer_counter / 1000);
                end
            end
            default: begin
                // DONE state: waiting for acknowledgement
                if (ack) begin
                    pattern_detector <= 4'b0000; // Transition to IDLE state
                    done <= 0;
                end
            end
        endcase
    end
end

endmodule