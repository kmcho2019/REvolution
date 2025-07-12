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
enum logic [2:0] {
    IDLE,
    SHIFT,
    COUNT,
    DONE
} state, next_state;

// Define counters
reg [1:0] shift_count;
reg [3:0] pattern;

// Initialize signals
initial begin
    state = IDLE;
    shift_ena = 0;
    counting = 0;
    done = 0;
    shift_count = 0;
    pattern = 0;
end

// Pattern detection and state machine logic
always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        shift_ena <= 0;
        counting <= 0;
        done <= 0;
        shift_count <= 0;
        pattern <= 0;
    end
    else begin
        case (state)
            IDLE: begin
                pattern <= {data, pattern[3:1]};
                if (pattern == 4'b1101) begin
                    next_state <= SHIFT;
                end
                else begin
                    next_state <= IDLE;
                end
            end
            SHIFT: begin
                shift_ena <= 1;
                shift_count <= shift_count + 1;
                if (shift_count == 4) begin
                    shift_ena <= 0;
                    next_state <= COUNT;
                end
                else begin
                    next_state <= SHIFT;
                end
            end
            COUNT: begin
                counting <= 1;
                if (done_counting) begin
                    next_state <= DONE;
                end
                else begin
                    next_state <= COUNT;
                end
            end
            DONE: begin
                done <= 1;
                if (ack) begin
                    next_state <= IDLE;
                end
                else begin
                    next_state <= DONE;
                end
            end
            default: begin
                next_state <= IDLE;
            end
        endcase
        state <= next_state;
    end
end

endmodule