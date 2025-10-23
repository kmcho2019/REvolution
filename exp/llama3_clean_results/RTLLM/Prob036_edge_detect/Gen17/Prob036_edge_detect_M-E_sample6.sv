module edge_detect(
    input         clk,      // Clock signal
    input         rst_n,    // Reset signal (active low)
    input         a,        // Input signal
    output reg    rise,     // Output signal indicating a rising edge
    output reg    down      // Output signal indicating a falling edge
);

reg prev_a;  // Register to store the previous state of 'a'
reg [1:0] curr_state;  // Register to store the current state of the FSM

// Define the states of the FSM
localparam IDLE = 2'b00;
localparam EDGE_DETECTED = 2'b01;

// Sequential logic to store the previous state of 'a' and reset
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset all signals to a known state
        prev_a <= 1'b0;
        curr_state <= IDLE;
        rise <= 1'b0;
        down <= 1'b0;
    end else begin
        case (curr_state)
            IDLE: begin
                prev_a <= a;
                if (a!== prev_a) begin
                    // Edge detected, transition to EDGE_DETECTED state
                    curr_state <= EDGE_DETECTED;
                end else begin
                    // No edge detected, stay in IDLE state
                    curr_state <= IDLE;
                end
            end
            EDGE_DETECTED: begin
                // Set rise or down signal accordingly
                if (a) begin
                    rise <= 1'b1;
                    down <= 1'b0;
                end else begin
                    rise <= 1'b0;
                    down <= 1'b1;
                end
                // Transition back to IDLE state
                curr_state <= IDLE;
            end
        endcase
    end
end

endmodule