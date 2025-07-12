// Define the TopModule with the given interface
module TopModule(
    input  clk,  // Clock signal
    input  aresetn,  // Asynchronous reset signal
    input  x,  // Input signal
    output z  // Output signal
);

// Define the state register
reg [1:0] shift_reg;  // 2-bit shift register

// Define the states
// S0: Initial state
// S1: 1 detected
// S2: 10 detected
reg [1:0] state;  // 2-bit state register

// Asynchronous reset and sequential logic
always_ff @(posedge clk or negedge aresetn) begin
    if (!aresetn) begin
        // Reset the shift register and state on asynchronous reset
        shift_reg <= 2'b00;
        state <= 2'b00;  // Reset to initial state
    end else begin
        // Shift in the new input on the positive clock edge
        shift_reg <= {shift_reg[0], x};
        
        // State machine logic
        case (state)
            2'b00: begin
                if (x == 1'b1) begin
                    state <= 2'b01;  // Move to S1 if 1 is detected
                end else begin
                    state <= 2'b00;  // Stay in S0 if 1 is not detected
                end
            end
            2'b01: begin
                if (x == 1'b0) begin
                    state <= 2'b10;  // Move to S2 if 0 is detected after 1
                end else begin
                    state <= 2'b01;  // Stay in S1 if 1 is detected again
                end
            end
            2'b10: begin
                if (x == 1'b1) begin
                    state <= 2'b01;  // Move back to S1 if 1 is detected after 10
                end else begin
                    state <= 2'b00;  // Reset to S0 if 0 is detected after 10
                end
            end
            default: state <= 2'b00;  // Default to S0
        endcase
    end
end

// Output logic: Assert z when the sequence "101" is detected
assign z = (state == 2'b10) && x;  // Assert z when in S2 and 1 is detected

endmodule