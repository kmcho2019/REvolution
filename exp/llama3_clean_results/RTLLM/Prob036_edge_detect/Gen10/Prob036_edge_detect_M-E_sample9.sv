module edge_detect (
    input  clk,          // Clock signal
    input  rst_n,        // Reset signal (active low)
    input  a,           // Input signal to detect edges
    output reg rise,     // Output signal indicating a rising edge
    output reg down      // Output signal indicating a falling edge
);

reg prev_a;            // Register to hold the previous state of 'a'
reg [1:0] state;       // State machine state (IDLE, EDGE_DETECTED)

// Initialize the output registers and state machine to IDLE
initial begin
    prev_a = 1'b0;
    rise = 1'b0;
    down = 1'b0;
    state = 2'b00; // IDLE state
end

// Store the previous state of 'a'
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin        // Reset condition
        prev_a <= 1'b0;
        rise <= 1'b0;
        down <= 1'b0;
        state <= 2'b00; // Reset to IDLE state
    end else begin
        prev_a <= a;
        
        // State machine logic
        case (state)
            2'b00: begin // IDLE state
                if (a != prev_a) begin
                    if (a) begin
                        rise <= 1'b1;
                        down <= 1'b0;
                    end else begin
                        rise <= 1'b0;
                        down <= 1'b1;
                    end
                    state <= 2'b01; // Transition to EDGE_DETECTED state
                end else begin
                    rise <= 1'b0;
                    down <= 1'b0;
                end
            end
            2'b01: begin // EDGE_DETECTED state
                rise <= 1'b0;
                down <= 1'b0;
                state <= 2'b00; // Return to IDLE state
            end
            default: begin
                state <= 2'b00; // Default to IDLE state
            end
        endcase
    end
end

endmodule