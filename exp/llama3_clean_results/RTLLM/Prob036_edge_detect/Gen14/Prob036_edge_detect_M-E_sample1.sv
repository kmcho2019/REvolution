module edge_detect(
    input         clk,      // Clock signal
    input         rst_n,    // Reset signal (active low)
    input         a,        // Input signal
    output reg    rise,     // Output signal indicating a rising edge
    output reg    down      // Output signal indicating a falling edge
);

reg [1:0] state;  // Register to store the current state of the FSM

// Define the states of the FSM
localparam IDLE = 2'b00;
localparam RISE_DETECTED = 2'b01;
localparam FALL_DETECTED = 2'b10;

reg prev_a;  // Register to store the previous state of 'a'

// Sequential logic to store the previous state of 'a'
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Explicitly reset the module to a known state
        prev_a <= 1'b0;
        state <= IDLE;
        rise <= 1'b0;
        down <= 1'b0;
    end else begin
        // Store the current state of 'a' in the previous state register
        prev_a <= a;
    end
end

// Sequential logic for the FSM
always @(posedge clk) begin
    case (state)
        IDLE: begin
            if (a &&!prev_a) begin
                // Rising edge detected, transition to RISE_DETECTED state
                state <= RISE_DETECTED;
                rise <= 1'b1;
                down <= 1'b0;
            end else if (!a && prev_a) begin
                // Falling edge detected, transition to FALL_DETECTED state
                state <= FALL_DETECTED;
                rise <= 1'b0;
                down <= 1'b1;
            end else begin
                // No edge detected, stay in IDLE state
                state <= IDLE;
                rise <= 1'b0;
                down <= 1'b0;
            end
        end
        RISE_DETECTED: begin
            // Reset the output signals and transition back to IDLE state
            state <= IDLE;
            rise <= 1'b0;
            down <= 1'b0;
        end
        FALL_DETECTED: begin
            // Reset the output signals and transition back to IDLE state
            state <= IDLE;
            rise <= 1'b0;
            down <= 1'b0;
        end
        default: begin
            // Invalid state, reset to IDLE state
            state <= IDLE;
            rise <= 1'b0;
            down <= 1'b0;
        end
    endcase
end

endmodule