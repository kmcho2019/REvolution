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
enum logic [1:0] {
    IDLE = 2'b00,
    SHIFT = 2'b01,
    COUNT = 2'b10,
    WAIT_ACK = 2'b11
} state, next_state;

// Define registers
reg [3:0] shift_count;
reg [3:0] pattern_count;

// Pattern detection logic
always @(posedge clk) begin
    if (reset) begin
        pattern_count <= 0;
    end
    else begin
        case (pattern_count)
            0: begin
                if (data == 1'b1) begin
                    pattern_count <= pattern_count + 1;
                end
            end
            1: begin
                if (data == 1'b1) begin
                    pattern_count <= pattern_count + 1;
                end
                else begin
                    pattern_count <= 0;
                end
            end
            2: begin
                if (data == 1'b0) begin
                    pattern_count <= pattern_count + 1;
                end
                else begin
                    pattern_count <= 0;
                end
            end
            3: begin
                if (data == 1'b1) begin
                    pattern_count <= 0;
                end
                else begin
                    pattern_count <= 0;
                end
            end
        endcase
    end
end

// Next state logic
always @(*) begin
    case (state)
        IDLE: begin
            if (pattern_count == 4) begin
                next_state = SHIFT;
            end
            else begin
                next_state = IDLE;
            end
        end
        SHIFT: begin
            if (shift_count == 4) begin
                next_state = COUNT;
            end
            else begin
                next_state = SHIFT;
            end
        end
        COUNT: begin
            if (done_counting) begin
                next_state = WAIT_ACK;
            end
            else begin
                next_state = COUNT;
            end
        end
        WAIT_ACK: begin
            if (ack) begin
                next_state = IDLE;
            end
            else begin
                next_state = WAIT_ACK;
            end
        end
    endcase
end

// State register
always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        shift_count <= 0;
        pattern_count <= 0;
        shift_ena <= 0;
        counting <= 0;
        done <= 0;
    end
    else begin
        state <= next_state;
        case (state)
            IDLE: begin
                shift_ena <= 0;
                counting <= 0;
                done <= 0;
            end
            SHIFT: begin
                shift_ena <= 1;
                if (shift_count == 4) begin
                    shift_ena <= 0;
                end
                shift_count <= shift_count + 1;
                counting <= 0;
                done <= 0;
            end
            COUNT: begin
                shift_ena <= 0;
                counting <= 1;
                if (done_counting) begin
                    counting <= 0;
                end
                done <= 0;
            end
            WAIT_ACK: begin
                shift_ena <= 0;
                counting <= 0;
                done <= 1;
                if (ack) begin
                    done <= 0;
                end
            end
        endcase
    end
end

endmodule