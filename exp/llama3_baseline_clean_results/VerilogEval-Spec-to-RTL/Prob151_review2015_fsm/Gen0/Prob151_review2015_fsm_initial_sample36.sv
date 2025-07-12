module TopModule (
    input               clk,
    input               reset,
    input               data,
    input               done_counting,
    input               ack,
    output reg          shift_ena,
    output reg          counting,
    output reg          done
);

// Define the states
enum logic [2:0] {
    IDLE,
    SHIFT,
    COUNT,
    DONE,
    ACK
} state, next_state;

// Counter for the number of shifts
reg [1:0] shift_count;
reg [3:0] pattern;

// Current state register
always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        pattern <= 0;
        shift_count <= 0;
        shift_ena <= 0;
        counting <= 0;
        done <= 0;
    end else begin
        state <= next_state;
        pattern <= {pattern[2:0], data};
        shift_count <= next_state == SHIFT ? shift_count + 1 : 0;
        shift_ena <= next_state == SHIFT;
        counting <= next_state == COUNT;
        done <= next_state == DONE;
    end
end

// Next state logic
always @(*) begin
    case (state)
        IDLE: begin
            if (pattern == 4'b1101) begin
                next_state = SHIFT;
            end else begin
                next_state = IDLE;
            end
        end
        SHIFT: begin
            if (shift_count == 4) begin
                next_state = COUNT;
            end else begin
                next_state = SHIFT;
            end
        end
        COUNT: begin
            if (done_counting) begin
                next_state = DONE;
            end else begin
                next_state = COUNT;
            end
        end
        DONE: begin
            if (ack) begin
                next_state = IDLE;
            end else begin
                next_state = DONE;
            end
        end
        default: next_state = IDLE;
    endcase
end

endmodule