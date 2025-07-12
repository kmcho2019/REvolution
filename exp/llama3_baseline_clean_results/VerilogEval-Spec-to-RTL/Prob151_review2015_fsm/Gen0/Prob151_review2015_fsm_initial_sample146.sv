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

// Define states
parameter IDLE = 4'b0000, 
           SHIFT = 4'b0001, 
           COUNT = 4'b0010, 
           NOTIFY = 4'b0011;

reg [3:0] state, next_state;
reg [3:0] shift_count;

always @(*) begin
    case (state)
        IDLE: begin
            if (/* pattern detected, assuming external logic */) 
                next_state = SHIFT;
            else
                next_state = IDLE;
        end
        SHIFT: begin
            if (shift_count == 4'd3) // After 4 cycles
                next_state = COUNT;
            else
                next_state = SHIFT;
        end
        COUNT: begin
            if (done_counting)
                next_state = NOTIFY;
            else
                next_state = COUNT;
        end
        NOTIFY: begin
            if (ack)
                next_state = IDLE;
            else
                next_state = NOTIFY;
        end
        default: next_state = IDLE;
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        shift_count <= 0;
        shift_ena <= 0;
        counting <= 0;
        done <= 0;
    end else begin
        state <= next_state;
        if (state == SHIFT) begin
            shift_ena <= 1;
            shift_count <= shift_count + 1;
        end else begin
            shift_ena <= 0;
            if (state == COUNT)
                counting <= 1;
            else
                counting <= 0;
            if (state == NOTIFY)
                done <= 1;
            else
                done <= 0;
        end
        if (next_state != SHIFT)
            shift_count <= 0;
    end
end

endmodule