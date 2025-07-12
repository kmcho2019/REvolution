module TopModule(
    input  clk,
    input  reset,
    input  data,
    input  done_counting,
    input  ack,
    output shift_ena,
    output counting,
    output done
);

// Define the states
parameter IDLE = 4'b0000;
parameter SHIFT = 4'b0001;
parameter COUNT = 4'b0010;
parameter DONE_ACK = 4'b0011;

reg [3:0] current_state;
reg [3:0] next_state;

// Shift counter
reg [1:0] shift_count;
reg shift_enable;

// Pattern detector
reg [3:0] pattern_detector;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        current_state <= IDLE;
        pattern_detector <= 4'b0000;
        shift_count <= 2'b00;
    end else begin
        current_state <= next_state;
        pattern_detector <= {pattern_detector[2:0], data};
        if (shift_enable) begin
            shift_count <= shift_count + 1'b1;
        end else begin
            shift_count <= 2'b00;
        end
    end
end

always @(*) begin
    case (current_state)
        IDLE: begin
            if (pattern_detector == 4'b1101) begin
                next_state = SHIFT;
            end else begin
                next_state = IDLE;
            end
        end
        SHIFT: begin
            if (shift_count == 2'b11) begin
                next_state = COUNT;
            end else begin
                next_state = SHIFT;
            end
        end
        COUNT: begin
            if (done_counting) begin
                next_state = DONE_ACK;
            end else begin
                next_state = COUNT;
            end
        end
        DONE_ACK: begin
            if (ack) begin
                next_state = IDLE;
            end else begin
                next_state = DONE_ACK;
            end
        end
        default: next_state = IDLE;
    endcase
end

always @(*) begin
    case (current_state)
        IDLE: begin
            shift_ena = 1'b0;
            counting = 1'b0;
            done = 1'b0;
            shift_enable = 1'b0;
        end
        SHIFT: begin
            shift_ena = 1'b1;
            counting = 1'b0;
            done = 1'b0;
            shift_enable = 1'b1;
        end
        COUNT: begin
            shift_ena = 1'b0;
            counting = 1'b1;
            done = 1'b0;
            shift_enable = 1'b0;
        end
        DONE_ACK: begin
            shift_ena = 1'b0;
            counting = 1'b0;
            done = 1'b1;
            shift_enable = 1'b0;
        end
        default: begin
            shift_ena = 1'b0;
            counting = 1'b0;
            done = 1'b0;
            shift_enable = 1'b0;
        end
    endcase
end

endmodule