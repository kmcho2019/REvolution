module edge_detect(
    input         clk,      // Clock signal
    input         rst_n,    // Reset signal (active low)
    input         a,        // Input signal
    output reg    rise,     // Output signal indicating a rising edge
    output reg    down      // Output signal indicating a falling edge
);

reg prev_a;  // Register to store the previous state of 'a'

// Sequential logic to update the previous state of 'a'
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset the module to a known state
        prev_a <= 1'b0;
        rise <= 1'b0;
        down <= 1'b0;
    end else begin
        // Update the previous state of 'a'
        prev_a <= a;
    end
end

// Combinational logic for edge detection and output update
always @(posedge clk) begin
    case ({a, prev_a})
        2'b01: begin
            // Rising edge detected
            rise <= 1'b1;
            down <= 1'b0;
        end
        2'b10: begin
            // Falling edge detected
            rise <= 1'b0;
            down <= 1'b1;
        end
        default: begin
            // No edge detected, reset the output signals
            rise <= 1'b0;
            down <= 1'b0;
        end
    endcase
end

endmodule