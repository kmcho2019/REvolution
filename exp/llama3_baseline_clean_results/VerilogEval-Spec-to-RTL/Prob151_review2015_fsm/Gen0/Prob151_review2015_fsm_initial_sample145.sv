module TopModule(
    input clk,
    input reset,
    input data,
    input done_counting,
    input ack,
    output shift_ena,
    output counting,
    output done
);

// Define states
enum {IDLE, SHIFT, COUNT, DONE_WAIT, DONE_ACK} state, next_state;

// Pattern detector
reg [3:0] pattern = 4'b1101;
reg [3:0] detected_pattern = 4'b0000;

// Counter for shifting
reg [1:0] shift_count = 2'b00;

// Shift enable, counting, and done outputs
assign shift_ena = (state == SHIFT);
assign counting = (state == COUNT);
assign done = (state == DONE_WAIT);

// Sequential logic
always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        detected_pattern <= 4'b0000;
        shift_count <= 2'b00;
    end else begin
        state <= next_state;
        detected_pattern <= {detected_pattern[2:0], data};
        if (state == SHIFT) begin
            shift_count <= shift_count + 1;
        end else begin
            shift_count <= 2'b00;
        end
    end
end

// Combinational logic
always @(*) begin
    case (state)
        IDLE: begin
            if (detected_pattern == pattern) begin
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
                next_state = DONE_WAIT;
            end else begin
                next_state = COUNT;
            end
        end
        DONE_WAIT: begin
            if (ack) begin
                next_state = DONE_ACK;
            end else begin
                next_state = DONE_WAIT;
            end
        end
        DONE_ACK: begin
            next_state = IDLE;
        end
        default: next_state = IDLE;
    endcase
end

endmodule