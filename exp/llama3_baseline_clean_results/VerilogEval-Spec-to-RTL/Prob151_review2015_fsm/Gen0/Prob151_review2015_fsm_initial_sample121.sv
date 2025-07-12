module TopModule (
    input clk,
    input reset,
    input data,
    input done_counting,
    input ack,
    output shift_ena,
    output counting,
    output done
);

// Define the states
enum logic [2:0] {
    IDLE = 3'b000,
    SHIFT = 3'b001,
    COUNTING = 3'b010,
    DONE = 3'b011,
    ACK = 3'b100
} state, next_state;

// Initialize the state
always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

// Define the next state logic
always_comb begin
    next_state = state;
    case (state)
        IDLE: begin
            // Detect the pattern (1101)
            if (data == 1'b1 && $past(data) == 1'b0 && $past($past(data)) == 1'b0 && $past($past($past(data))) == 1'b1) begin
                next_state = SHIFT;
            end
        end
        SHIFT: begin
            // Shift in 4 more bits
            if ($past(clk) == 1'b1 && $past(clk) != clk && $global_cycle == 4) begin
                next_state = COUNTING;
            end
        end
        COUNTING: begin
            // Wait for the counters to finish counting
            if (done_counting) begin
                next_state = DONE;
            end
        end
        DONE: begin
            // Notify the user and wait for acknowledgment
            if (ack) begin
                next_state = ACK;
            end
        end
        ACK: begin
            // Reset to the initial state
            next_state = IDLE;
        end
        default: next_state = IDLE;
    endcase
end

// Define the output logic
assign shift_ena = (state == SHIFT);
assign counting = (state == COUNTING);
assign done = (state == DONE);

// For simulation purposes
reg [2:0] $global_cycle;
always_ff @(posedge clk) begin
    if (reset) begin
        $global_cycle <= 0;
    end else if (state == SHIFT) begin
        $global_cycle <= $global_cycle + 1;
    end else begin
        $global_cycle <= 0;
    end
end

endmodule