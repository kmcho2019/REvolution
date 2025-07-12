module edge_detect(
    input         clk,      // Clock signal
    input         rst_n,    // Reset signal (active low)
    input         a,        // Input signal
    output reg    rise,     // Output signal indicating a rising edge
    output reg    down      // Output signal indicating a falling edge
);

reg [1:0] state;  // State register for the FSM
reg prev_a;        // Register to store the previous state of 'a'

// Sequential logic for the state register and previous state of 'a'
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= 2'b00;  // Reset state to IDLE
        prev_a <= 1'b0;
        rise <= 1'b0;
        down <= 1'b0;
    end else begin
        case (state)
            2'b00: begin  // IDLE state
                if (a !== prev_a) begin
                    if (a) begin
                        state <= 2'b01;  // Transition to EDGE_DETECTED for rising edge
                    end else begin
                        state <= 2'b10;  // Transition to EDGE_DETECTED for falling edge
                    end
                end
            end
            2'b01: begin  // EDGE_DETECTED for rising edge
                rise <= 1'b1;
                state <= 2'b00;  // Return to IDLE
            end
            2'b10: begin  // EDGE_DETECTED for falling edge
                down <= 1'b1;
                state <= 2'b00;  // Return to IDLE
            end
            default: state <= 2'b00;
        endcase
        prev_a <= a;
        if (state == 2'b00) begin
            rise <= 1'b0;
            down <= 1'b0;
        end
    end
end

endmodule