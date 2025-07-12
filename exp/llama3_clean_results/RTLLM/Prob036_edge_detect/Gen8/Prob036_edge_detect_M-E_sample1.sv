module edge_detect (
    input  clk,          // Clock signal
    input  rst_n,        // Reset signal (active low)
    input  a,           // Input signal to detect edges
    output reg rise,     // Output signal indicating a rising edge
    output reg down      // Output signal indicating a falling edge
);

reg [1:0] state;        // FSM state: 0 - low, 1 - high, 2 - transition

// Initialize the FSM state and output registers
initial begin
    state = 2'b00;
    rise = 1'b0;
    down = 1'b0;
end

// FSM logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin        // Reset condition
        state <= 2'b00;
        rise <= 1'b0;
        down <= 1'b0;
    end else begin
        case (state)
            2'b00: begin        // Low state
                if (a) begin
                    state <= 2'b11;    // Transition to high
                    rise <= 1'b1;
                    down <= 1'b0;
                end else begin
                    state <= 2'b00;    // Stay in low
                    rise <= 1'b0;
                    down <= 1'b0;
                end
            end
            2'b01: begin        // High state
                if (~a) begin
                    state <= 2'b10;    // Transition to low
                    rise <= 1'b0;
                    down <= 1'b1;
                end else begin
                    state <= 2'b01;    // Stay in high
                    rise <= 1'b0;
                    down <= 1'b0;
                end
            end
            2'b10: begin        // Transition to low
                state <= 2'b00;    // Go to low
                rise <= 1'b0;
                down <= 1'b0;
            end
            2'b11: begin        // Transition to high
                state <= 2'b01;    // Go to high
                rise <= 1'b0;
                down <= 1'b0;
            end
            default: begin
                state <= 2'b00;    // Default to low
                rise <= 1'b0;
                down <= 1'b0;
            end
        endcase
    end
end

endmodule