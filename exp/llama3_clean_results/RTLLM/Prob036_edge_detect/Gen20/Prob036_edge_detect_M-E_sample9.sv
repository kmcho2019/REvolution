module edge_detect(
    input         clk,      // Clock signal
    input         rst_n,    // Reset signal (active low)
    input         a,        // Input signal
    output reg    rise,     // Output signal indicating a rising edge
    output reg    down      // Output signal indicating a falling edge
);

reg [1:0] state;  // Finite state machine (FSM) states
reg prev_a;      // Register to store the previous state of 'a'

// Sequential logic to store the previous state of 'a'
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Explicitly reset the module to a known state
        prev_a <= 1'b0;
        state <= 2'b00;  // IDLE state
    end else begin
        // Store the current state of 'a' in the previous state register
        prev_a <= a;
    end
end

// FSM logic to detect edges
always @(posedge clk) begin
    case (state)
        2'b00: begin  // IDLE state
            if (a &&!prev_a) begin
                state <= 2'b01;  // RISING_EDGE state
                rise <= 1'b1;
                down <= 1'b0;
            end else if (!a && prev_a) begin
                state <= 2'b10;  // FALLING_EDGE state
                rise <= 1'b0;
                down <= 1'b1;
            end else begin
                state <= 2'b00;  // IDLE state
                rise <= 1'b0;
                down <= 1'b0;
            end
        end
        2'b01: begin  // RISING_EDGE state
            state <= 2'b00;  // IDLE state
            rise <= 1'b0;
            down <= 1'b0;
        end
        2'b10: begin  // FALLING_EDGE state
            state <= 2'b00;  // IDLE state
            rise <= 1'b0;
            down <= 1'b0;
        end
        default: begin
            state <= 2'b00;  // IDLE state
            rise <= 1'b0;
            down <= 1'b0;
        end
    endcase
end

endmodule