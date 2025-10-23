module edge_detect(
    input         clk,      // Clock signal
    input         rst_n,    // Reset signal (active low)
    input         a,        // Input signal
    output reg    rise,     // Output signal indicating a rising edge
    output reg    down      // Output signal indicating a falling edge
);

// Define the FSM states
enum logic [1:0] {IDLE, RISE_DETECTED, FALL_DETECTED} state, next_state;

// Sequential logic for the FSM
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset the FSM to the idle state
        state <= IDLE;
        rise <= 1'b0;
        down <= 1'b0;
    end else begin
        // Update the FSM state
        state <= next_state;
        // Update the output signals based on the FSM state
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
        endcase
    end
end

// Combinational logic for the FSM transitions
always @(*) begin
    case (state)
        IDLE: begin
            if (a) begin
                // Detect rising edge
                next_state = RISE_DETECTED;
            end else if (~a) begin
                // Detect falling edge
                next_state = FALL_DETECTED;
            end else begin
                // No edge detected, stay in idle state
                next_state = IDLE;
            end
        end
        RISE_DETECTED: begin
            // Reset to idle state after one clock cycle
            next_state = IDLE;
        end
        FALL_DETECTED: begin
            // Reset to idle state after one clock cycle
            next_state = IDLE;
        end
    endcase
end

endmodule