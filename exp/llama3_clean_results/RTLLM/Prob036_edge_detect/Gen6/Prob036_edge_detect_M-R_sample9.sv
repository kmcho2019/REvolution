module edge_detect(
    input         clk,      // Clock signal
    input         rst_n,    // Reset signal (active low)
    input         a,        // Input signal
    output        rise,     // Output signal indicating a rising edge
    output        down      // Output signal indicating a falling edge
);

reg prev_a;  // Register to store the previous state of 'a'

// Sequential logic to store the previous state of 'a'
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        prev_a <= 1'b0;
    end else begin
        prev_a <= a;
    end
end

// Combinational logic for edge detection using a case statement
// for explicit state machine representation
always @(*) begin
    case ({prev_a, a})
        2'b01: begin  // Previous state 0, current state 1 (Rising edge)
            rise = 1'b1;
            down = 1'b0;
        end
        2'b10: begin  // Previous state 1, current state 0 (Falling edge)
            rise = 1'b0;
            down = 1'b1;
        end
        default: begin  // No edge
            rise = 1'b0;
            down = 1'b0;
        end
    endcase
end

endmodule