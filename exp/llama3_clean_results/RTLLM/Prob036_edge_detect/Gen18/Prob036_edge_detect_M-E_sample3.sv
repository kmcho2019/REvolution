module edge_detect(
    input         clk,      // Clock signal
    input         rst_n,    // Reset signal (active low)
    input         a,        // Input signal
    output reg    rise,     // Output signal indicating a rising edge
    output reg    down      // Output signal indicating a falling edge
);

// Define the states of the FSM
enum logic [1:0] {IDLE, RISE_DETECTED, FALL_DETECTED} state, next_state;

// Sequential logic for the FSM
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset the FSM to the IDLE state
        state <= IDLE;
        rise <= 1'b0;
        down <= 1'b0;
    end else begin
        // Update the state and output signals based on the next state
        state <= next_state;
        case (state)
            IDLE: begin
                rise <= 1'b0;
                down <= 1'b0;
            end
            RISE_DETECTED: begin
                rise <= 1'b1;
                down <= 1'b0;
            end
            FALL_DETECTED: begin
                rise <= 1'b0;
                down <= 1'b1;
            end
            default: begin
                rise <= 1'b0;
                down <= 1'b0;
            end
        endcase
    end
end

// Combinational logic to determine the next state
always @(*) begin
    case (state)
        IDLE: begin
            if (a) begin
                // If 'a' is high, wait for it to go low
                next_state = IDLE;
            end else if (~a) begin
                // If 'a' is low, wait for it to go high
                next_state = IDLE;
            end else begin
                // This should not happen
                next_state = IDLE;
            end
        end
        RISE_DETECTED: begin
            next_state = IDLE;
        end
        FALL_DETECTED: begin
            next_state = IDLE;
        end
        default: begin
            next_state = IDLE;
        end
    endcase
    
    // Check for rising and falling edges
    if (state == IDLE) begin
        if (a && ~prev_a) begin
            next_state = RISE_DETECTED;
        end else if (~a && prev_a) begin
            next_state = FALL_DETECTED;
        end
    end
end

reg prev_a;  // Register to store the previous state of 'a'
always @(posedge clk) begin
    prev_a <= a;
end

endmodule