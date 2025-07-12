module edge_detect(
    input         clk,      // Clock signal
    input         rst_n,    // Reset signal (active low)
    input         a,        // Input signal
    output reg    rise,     // Output signal indicating a rising edge
    output reg    down      // Output signal indicating a falling edge
);

reg prev_a;  // Register to store the previous state of 'a'
reg [1:0] state;  // Finite State Machine state register

// Define the states of the FSM
localparam IDLE = 2'b00;
localparam RISE_DETECTED = 2'b01;
localparam FALL_DETECTED = 2'b10;

// Sequential logic to update the previous state of 'a' and FSM state
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset the module to a known state
        prev_a <= 1'b0;
        state <= IDLE;
        rise <= 1'b0;
        down <= 1'b0;
    end else begin
        // Update the previous state of 'a'
        prev_a <= a;

        // Update the FSM state
        case (state)
            IDLE: begin
                if (a && !prev_a) begin
                    // Rising edge detected
                    state <= RISE_DETECTED;
                end else if (!a && prev_a) begin
                    // Falling edge detected
                    state <= FALL_DETECTED;
                end else begin
                    // No edge detected, stay in IDLE state
                    state <= IDLE;
                end
            end
            RISE_DETECTED: begin
                // Set the rise signal and transition back to IDLE
                rise <= 1'b1;
                state <= IDLE;
            end
            FALL_DETECTED: begin
                // Set the down signal and transition back to IDLE
                down <= 1'b1;
                state <= IDLE;
            end
            default: state <= IDLE;
        endcase

        // Reset the output signals unless an edge is detected
        if (state == IDLE) begin
            rise <= 1'b0;
            down <= 1'b0;
        end
    end
end

endmodule