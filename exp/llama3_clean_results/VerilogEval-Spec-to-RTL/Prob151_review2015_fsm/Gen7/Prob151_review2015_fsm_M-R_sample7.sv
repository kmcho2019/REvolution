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

// Define the states
enum logic [2:0] {
    IDLE,
    SHIFT,
    COUNT,
    DONE_ACK
} state, next_state;

// Pattern detection
reg [3:0] pattern_det;
always @(posedge clk) begin
    if (reset) begin
        pattern_det <= 4'b0000;
    end
    else begin
        pattern_det <= {pattern_det[2:0], data};
    end
end

// Shift count and duration
reg [3:0] shift_count;
reg [3:0] duration;
always @(posedge clk) begin
    if (reset) begin
        shift_count <= 4'b0000;
        duration <= 4'b0000;
    end
    else if (state == SHIFT) begin
        duration <= {duration[2:0], data};
        shift_count <= shift_count + 1;
    end
end

// State machine
always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        shift_ena <= 0;
        counting <= 0;
        done <= 0;
    end
    else begin
        state <= next_state;
        case (state)
            IDLE: begin
                if (pattern_det == 4'b1101) begin
                    next_state <= SHIFT;
                    shift_ena <= 1;
                end
                else begin
                    next_state <= IDLE;
                    shift_ena <= 0;
                end
            end
            SHIFT: begin
                if (shift_count == 4'b0100) begin
                    next_state <= COUNT;
                    shift_ena <= 0;
                    counting <= 1;
                end
                else begin
                    next_state <= SHIFT;
                end
            end
            COUNT: begin
                if (done_counting) begin
                    next_state <= DONE_ACK;
                    counting <= 0;
                    done <= 1;
                end
                else begin
                    next_state <= COUNT;
                end
            end
            DONE_ACK: begin
                if (ack) begin
                    next_state <= IDLE;
                    done <= 0;
                end
                else begin
                    next_state <= DONE_ACK;
                end
            end
        endcase
    end
end

endmodule