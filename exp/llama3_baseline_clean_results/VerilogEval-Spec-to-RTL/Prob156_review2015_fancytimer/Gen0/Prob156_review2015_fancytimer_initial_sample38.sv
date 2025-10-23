module TopModule(
    input clk,
    input reset,
    input data,
    output [3:0] count,
    output counting,
    output done,
    input ack
);

// Define states
parameter IDLE = 0, SHIFT = 1, COUNT = 2, DONE = 3;

// State register
reg [1:0] state;
reg [1:0] next_state;

// Delay register
reg [3:0] delay;

// Count register
reg [3:0] remaining_count;

// Clock cycle counter
reg [9:0] clock_cycle_counter;

// Pattern detector
reg [3:0] pattern_detector;

// Initialize state and counters
initial begin
    state = IDLE;
    next_state = IDLE;
    delay = 0;
    remaining_count = 0;
    clock_cycle_counter = 0;
    pattern_detector = 0;
end

// Update state and counters
always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        next_state <= IDLE;
        delay <= 0;
        remaining_count <= 0;
        clock_cycle_counter <= 0;
        pattern_detector <= 0;
        counting <= 0;
        done <= 0;
    end else begin
        // Update state
        state <= next_state;

        // Update pattern detector
        if (state == IDLE) begin
            pattern_detector <= {data, pattern_detector[3:1]};
            if (pattern_detector == 4'b1101) begin
                next_state <= SHIFT;
            end else begin
                next_state <= IDLE;
            end
        end

        // Update delay
        if (state == SHIFT) begin
            delay <= {data, delay[3:1]};
            next_state <= (delay == 4'b1000) ? COUNT : SHIFT;
        end

        // Update count
        if (state == COUNT) begin
            if (clock_cycle_counter == 1000) begin
                remaining_count <= remaining_count - 1;
                clock_cycle_counter <= 0;
            end
            clock_cycle_counter <= clock_cycle_counter + 1;
            if (remaining_count == 0) begin
                next_state <= DONE;
            end
        end

        // Update done and counting
        if (state == DONE) begin
            done <= 1;
            if (ack) begin
                next_state <= IDLE;
                done <= 0;
            end
        end else if (state == COUNT) begin
            counting <= 1;
        end else begin
            counting <= 0;
        end

        // Update count output
        if (state == COUNT) begin
            count <= remaining_count;
        end else begin
            count <= 0;
        end

        // Initialize count and remaining count
        if (next_state == COUNT) begin
            remaining_count <= delay + 1;
        end
    end
end

endmodule