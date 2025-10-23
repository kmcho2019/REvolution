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
enum logic [2:0] {
    Idle,
    Shift,
    Count,
    DoneAck
} state, next_state;

// Pattern detection variables
reg [3:0] pattern_det;
reg [1:0] shift_count;

always @(*) begin
    // Default values
    next_state = state;
    shift_ena = 0;
    counting = 0;
    done = 0;

    case(state)
        Idle: begin
            if (pattern_det == 4'b1101) begin
                next_state = Shift;
                shift_count = 0;
            end
            else begin
                next_state = Idle;
            end
            if (data) begin
                pattern_det = {pattern_det[2:0], 1'b1};
            end
            else begin
                pattern_det = {pattern_det[2:0], 1'b0};
            end
        end

        Shift: begin
            shift_ena = 1;
            shift_count = shift_count + 1;
            if (shift_count == 4) begin
                next_state = Count;
            end
            else begin
                next_state = Shift;
            end
        end

        Count: begin
            counting = 1;
            if (done_counting) begin
                next_state = DoneAck;
            end
            else begin
                next_state = Count;
            end
        end

        DoneAck: begin
            done = 1;
            if (ack) begin
                next_state = Idle;
            end
            else begin
                next_state = DoneAck;
            end
        end
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        state <= Idle;
        pattern_det <= 0;
        shift_count <= 0;
    end
    else begin
        state <= next_state;
    end
end

endmodule