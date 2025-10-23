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

reg [3:0] shift_count;
reg [3:0] sequence_count;

// Pattern detection and state machine
always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        shift_count <= 0;
        sequence_count <= 0;
    end
    else begin
        case (state)
            IDLE: begin
                if (sequence_count == 4) begin
                    state <= SHIFT;
                    shift_count <= 0;
                end
                else begin
                    state <= IDLE;
                end
            end
            SHIFT: begin
                if (shift_count == 4) begin
                    state <= COUNT;
                end
                else begin
                    state <= SHIFT;
                    shift_count <= shift_count + 1;
                end
            end
            COUNT: begin
                if (done_counting) begin
                    state <= WAIT_ACK;
                end
                else begin
                    state <= COUNT;
                end
            end
            WAIT_ACK: begin
                if (ack) begin
                    state <= IDLE;
                    sequence_count <= 0;
                end
                else begin
                    state <= WAIT_ACK;
                end
            end
        endcase
    end
end

// Sequence detection
always @(posedge clk) begin
    if (reset) begin
        sequence_count <= 0;
    end
    else if (state == IDLE) begin
        if (data == 1'b1 && sequence_count == 0) begin
            sequence_count <= sequence_count + 1;
        end
        else if (data == 1'b1 && sequence_count == 1) begin
            sequence_count <= sequence_count + 1;
        end
        else if (data == 1'b0 && sequence_count == 2) begin
            sequence_count <= sequence_count + 1;
        end
        else if (data == 1'b1 && sequence_count == 3) begin
            sequence_count <= sequence_count + 1;
        end
        else begin
            sequence_count <= 0;
        end
    end
end

// Output assignment
always @(posedge clk) begin
    if (reset) begin
        shift_ena <= 0;
        counting <= 0;
        done <= 0;
    end
    else begin
        case (state)
            IDLE: begin
                shift_ena <= 0;
                counting <= 0;
                done <= 0;
            end
            SHIFT: begin
                shift_ena <= 1;
                counting <= 0;
                done <= 0;
            end
            COUNT: begin
                shift_ena <= 0;
                counting <= 1;
                done <= 0;
            end
            WAIT_ACK: begin
                shift_ena <= 0;
                counting <= 0;
                done <= 1;
            end
        endcase
    end
end

endmodule