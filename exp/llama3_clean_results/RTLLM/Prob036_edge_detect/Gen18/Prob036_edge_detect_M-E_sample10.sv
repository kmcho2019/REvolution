module edge_detect(
    input         clk,      // Clock signal
    input         rst_n,    // Reset signal (active low)
    input         a,        // Input signal
    output reg    rise,     // Output signal indicating a rising edge
    output reg    down      // Output signal indicating a falling edge
);

// Define the states of the state machine
enum logic [1:0] {STABLE, EDGE_DETECTED_RISE, EDGE_DETECTED_FALL} state, next_state;

// Sequential logic for the state machine
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset the state machine and output signals
        state <= STABLE;
        rise <= 1'b0;
        down <= 1'b0;
    end else begin
        // Update the state based on the next state
        state <= next_state;
        
        // Update the output signals based on the current state
        case (state)
            STABLE: begin
                rise <= 1'b0;
                down <= 1'b0;
            end
            EDGE_DETECTED_RISE: begin
                rise <= 1'b1;
                down <= 1'b0;
            end
            EDGE_DETECTED_FALL: begin
                rise <= 1'b0;
                down <= 1'b1;
            end
        endcase
    end
end

// Combinational logic to determine the next state
always @(*) begin
    case (state)
        STABLE: begin
            if (a) begin
                // If 'a' is high and was previously low, detect a rising edge
                if (~prev_a) begin
                    next_state = EDGE_DETECTED_RISE;
                end else begin
                    next_state = STABLE;
                end
            end else begin
                // If 'a' is low and was previously high, detect a falling edge
                if (prev_a) begin
                    next_state = EDGE_DETECTED_FALL;
                end else begin
                    next_state = STABLE;
                end
            end
        end
        EDGE_DETECTED_RISE, EDGE_DETECTED_FALL: begin
            // After detecting an edge, return to the stable state
            next_state = STABLE;
        end
    endcase
end

reg prev_a;  // Register to store the previous state of 'a'
always @(posedge clk) begin
    prev_a <= a;
end

endmodule