module edge_detect(
    input         clk,      // Clock signal
    input         rst_n,    // Reset signal (active low)
    input         a,        // Input signal
    output        rise,     // Output signal indicating a rising edge
    output        down      // Output signal indicating a falling edge
);

reg prev_a;  // Register to store the previous state of 'a'
reg rise_reg, down_reg;  // Registers to store the detected edges

// Sequential logic to store the previous state of 'a' and detected edges
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Explicitly reset the module to a known state
        prev_a <= 1'b0;
        rise_reg <= 1'b0;
        down_reg <= 1'b0;
    end else begin
        // Store the current state of 'a' in the previous state register
        prev_a <= a;
        
        // Update the edge detection status registers
        if (a && !prev_a) begin
            rise_reg <= 1'b1;
            down_reg <= 1'b0;
        end else if (!a && prev_a) begin
            rise_reg <= 1'b0;
            down_reg <= 1'b1;
        end else begin
            rise_reg <= 1'b0;
            down_reg <= 1'b0;
        end
    end
end

// Drive the output signals directly from the edge detection status registers
assign rise = rise_reg;
assign down = down_reg;

endmodule