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

// Define the states of the FSM
parameter IDLE = 4'b0000;
parameter SHIFT = 4'b0001;
parameter COUNTING = 4'b0010;
parameter DONE = 4'b0011;

// Define the state register
reg [3:0] state;
reg [3:0] next_state;

// Define the shift counter
reg [1:0] shift_count;
reg [1:0] next_shift_count;

// Define the pattern detector
reg [3:0] pattern_detector;
reg [3:0] next_pattern_detector;

// FSM logic
always @(*)
begin
    // Default values
    next_state = state;
    next_shift_count = shift_count;
    next_pattern_detector = pattern_detector;

    // IDLE state
    if (state == IDLE)
    begin
        if (pattern_detector == 4'b1101)
        begin
            next_state = SHIFT;
            next_shift_count = 0;
            next_pattern_detector = 0;
        end
        else
        begin
            next_pattern_detector = {pattern_detector[2:0], data};
        end
    end
    // SHIFT state
    else if (state == SHIFT)
    begin
        if (shift_count == 3)
        begin
            next_state = COUNTING;
        end
        else
        begin
            next_shift_count = shift_count + 1;
        end
    end
    // COUNTING state
    else if (state == COUNTING)
    begin
        if (done_counting)
        begin
            next_state = DONE;
        end
    end
    // DONE state
    else if (state == DONE)
    begin
        if (ack)
        begin
            next_state = IDLE;
        end
    end
end

// Sequential logic
always @(posedge clk)
begin
    if (reset)
    begin
        state <= IDLE;
        shift_count <= 0;
        pattern_detector <= 0;
    end
    else
    begin
        state <= next_state;
        shift_count <= next_shift_count;
        pattern_detector <= next_pattern_detector;
    end
end

// Output logic
assign shift_ena = (state == SHIFT);
assign counting = (state == COUNTING);
assign done = (state == DONE);

endmodule