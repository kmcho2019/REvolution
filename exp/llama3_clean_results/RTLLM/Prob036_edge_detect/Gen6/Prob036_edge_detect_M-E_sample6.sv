module edge_detect (
    input  clk,          // Clock signal
    input  rst_n,        // Reset signal (active low)
    input  a,           // Input signal to detect edges
    output reg rise,     // Output signal indicating a rising edge
    output reg down      // Output signal indicating a falling edge
);

reg [1:0] state;        // FSM state register (0: low, 1: high)

// Initialize the FSM state and output registers
initial begin
    state = 2'b00;      // Initial state: low
    rise = 1'b0;
    down = 1'b0;
end

// FSM logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin        // Reset condition
        state <= 2'b00;      // Reset to low state
        rise <= 1'b0;
        down <= 1'b0;
    end else begin
        case (state)
            2'b00: begin     // Current state: low
                if (a) begin  // Rising edge detected
                    state <= 2'b01;  // Transition to high state
                    rise <= 1'b1;
                    down <= 1'b0;
                end else begin
                    state <= 2'b00;  // Remain in low state
                    rise <= 1'b0;
                    down <= 1'b0;
                end
            end
            2'b01: begin     // Current state: high
                if (~a) begin  // Falling edge detected
                    state <= 2'b00;  // Transition to low state
                    rise <= 1'b0;
                    down <= 1'b1;
                end else begin
                    state <= 2'b01;  // Remain in high state
                    rise <= 1'b0;
                    down <= 1'b0;
                end
            end
            default: begin
                state <= 2'b00;      // Reset to low state
                rise <= 1'b0;
                down <= 1'b0;
            end
        endcase
    end
end

endmodule