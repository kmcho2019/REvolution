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
parameter IDLE = 0;
parameter SHIFT = 1;
parameter COUNTING = 2;
parameter DONE = 3;

// State register declaration
reg [1:0] state;
reg [1:0] next_state;

// Pattern detection signals
reg [3:0] pattern;
reg pattern_match;

// Counter for shift state
reg [1:0] shift_count;
reg [1:0] next_shift_count;

// Output logic
assign shift_ena = (state == SHIFT);
assign counting = (state == COUNTING);
assign done = (state == DONE);

// Pattern detection logic
always @(posedge clk) begin
    if (reset) begin
        pattern <= 4'd0;
    end else begin
        pattern <= {pattern[2:0], data};
    end
end

assign pattern_match = (pattern == 4'd13); // 1101 in decimal is 13

// State machine
always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        shift_count <= 2'd0;
    end else begin
        state <= next_state;
        shift_count <= next_shift_count;
    end
end

// Next state logic
always @(*) begin
    next_state = state;
    next_shift_count = shift_count;
    case (state)
        IDLE: begin
            if (pattern_match) begin
                next_state = SHIFT;
            end
        end
        SHIFT: begin
            next_shift_count = shift_count + 1;
            if (shift_count == 2'd3) begin // After 4 clock cycles
                next_state = COUNTING;
            end
        end
        COUNTING: begin
            if (done_counting) begin
                next_state = DONE;
            end
        end
        DONE: begin
            if (ack) begin
                next_state = IDLE;
            end
        end
    endcase
end

endmodule