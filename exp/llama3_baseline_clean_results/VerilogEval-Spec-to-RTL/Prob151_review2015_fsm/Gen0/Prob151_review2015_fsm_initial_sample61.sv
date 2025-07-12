module TopModule(
    input clk,
    input reset,
    input data,
    input done_counting,
    input ack,
    output reg shift_ena,
    output reg counting,
    output reg done
);

// States of the finite-state machine
localparam IDLE = 0;
localparam SHIFT = 1;
localparam COUNT = 2;
localparam DONE = 3;
reg [1:0] state;

// Counter for shifting bits
reg [1:0] shift_cnt;

// Pattern detection registers
reg [3:0] pattern;

always @(posedge clk) begin
    if (reset) begin
        // Reset state to IDLE and clear counters
        state <= IDLE;
        shift_cnt <= 0;
        shift_ena <= 0;
        counting <= 0;
        done <= 0;
        pattern <= 0;
    end else begin
        case (state)
            IDLE: begin
                // Shift in the pattern
                pattern <= {data, pattern[3:1]};
                if (pattern == 4'b1101) begin
                    // Start shifting bits
                    state <= SHIFT;
                    shift_cnt <= 1;
                end
            end
            SHIFT: begin
                // Assert shift_ena and shift in bits
                shift_ena <= 1;
                if (shift_cnt == 4) begin
                    state <= COUNT;
                    shift_ena <= 0;
                end else begin
                    shift_cnt <= shift_cnt + 1;
                end
            end
            COUNT: begin
                // Assert counting and wait for done_counting
                counting <= 1;
                if (done_counting) begin
                    state <= DONE;
                    counting <= 0;
                end
            end
            DONE: begin
                // Assert done and wait for ack
                done <= 1;
                if (ack) begin
                    state <= IDLE;
                    done <= 0;
                end
            end
            default: state <= IDLE;
        endcase
    end
end

endmodule