module edge_detect(
    input         clk,      // Clock signal
    input         rst_n,    // Reset signal (active low)
    input         a,        // Input signal
    output reg    rise,     // Output signal indicating a rising edge
    output reg    down      // Output signal indicating a falling edge
);

reg [1:0] shift_reg;  // 2-bit shift register to store current and previous states of 'a'

// Sequential logic to store the current and previous states of 'a' in the shift register
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset the shift register and output signals
        shift_reg <= 2'b00;
        rise <= 1'b0;
        down <= 1'b0;
    end else begin
        // Shift the current state of 'a' into the shift register
        shift_reg <= {a, shift_reg[0]};
    end
end

// Combinational logic to detect rising and falling edges
always @(*) begin
    case (shift_reg)
        2'b01: begin
            // Rising edge detected, set 'rise' to 1
            rise = 1'b1;
            down = 1'b0;
        end
        2'b10: begin
            // Falling edge detected, set 'down' to 1
            rise = 1'b0;
            down = 1'b1;
        end
        default: begin
            // No edge detected, reset 'rise' and 'down' to 0
            rise = 1'b0;
            down = 1'b0;
        end
    endcase
end

// Reset the output signals on the next clock cycle after an edge is detected
always @(posedge clk) begin
    if (rise || down) begin
        rise <= 1'b0;
        down <= 1'b0;
    end
end

endmodule