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

// Define states
parameter IDLE = 4'd0;
parameter SHIFT = 4'd1;
parameter COUNTING = 4'd2;
parameter DONE = 4'd3;

// State register
reg [3:0] state;
reg [3:0] next_state;

// Pattern detection
reg [3:0] pattern;
reg [3:0] next_pattern;

// Shift counter
reg [1:0] shift_count;
reg [1:0] next_shift_count;

always @(*) begin
    // Next state logic
    case (state)
        IDLE: begin
            if (pattern == 4'd13) begin // 1101
                next_state = SHIFT;
            end else begin
                next_state = IDLE;
            end
        end
        SHIFT: begin
            if (shift_count == 2'd3) begin // 4 clock cycles
                next_state = COUNTING;
            end else begin
                next_state = SHIFT;
            end
        end
        COUNTING: begin
            if (done_counting) begin
                next_state = DONE;
            end else begin
                next_state = COUNTING;
            end
        end
        DONE: begin
            if (ack) begin
                next_state = IDLE;
            end else begin
                next_state = DONE;
            end
        end
        default: begin
            next_state = IDLE;
        end
    endcase

    // Pattern detection
    case (pattern)
        4'd0: begin
            if (data) begin
                next_pattern = 4'd1;
            end else begin
                next_pattern = 4'd0;
            end
        end
        4'd1: begin
            if (data) begin
                next_pattern = 4'd3;
            end else begin
                next_pattern = 4'd0;
            end
        end
        4'd3: begin
            if (data) begin
                next_pattern = 4'd7;
            end else begin
                next_pattern = 4'd0;
            end
        end
        4'd7: begin
            if (data) begin
                next_pattern = 4'd13;
            end else begin
                next_pattern = 4'd0;
            end
        end
        4'd13: begin
            if (data) begin
                next_pattern = 4'd13;
            end else begin
                next_pattern = 4'd8;
            end
        end
        4'd8: begin
            if (data) begin
                next_pattern = 4'd9;
            end else begin
                next_pattern = 4'd0;
            end
        end
        4'd9: begin
            if (data) begin
                next_pattern = 4'd11;
            end else begin
                next_pattern = 4'd0;
            end
        end
        4'd11: begin
            if (data) begin
                next_pattern = 4'd13;
            end else begin
                next_pattern = 4'd0;
            end
        end
        default: begin
            next_pattern = 4'd0;
        end
    endcase

    // Shift counter
    if (state == SHIFT) begin
        if (shift_count == 2'd3) begin
            next_shift_count = 2'd0;
        end else begin
            next_shift_count = shift_count + 1;
        end
    end else begin
        next_shift_count = 2'd0;
    end

    // Output logic
    shift_ena = (state == SHIFT);
    counting = (state == COUNTING);
    done = (state == DONE);
end

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        pattern <= 4'd0;
        shift_count <= 2'd0;
    end else begin
        state <= next_state;
        pattern <= next_pattern;
        shift_count <= next_shift_count;
    end
end

endmodule