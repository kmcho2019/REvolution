module edge_detect(
    input         clk,      // Clock signal
    input         rst_n,    // Reset signal (active low)
    input         a,        // Input signal
    output        rise,     // Output signal indicating a rising edge
    output        down      // Output signal indicating a falling edge
);

reg prev_a;  // Register to store the previous state of 'a'
reg rise_reg;  // Register for rise signal
reg down_reg;  // Register for down signal

// Sequential logic for edge detection and storing previous state
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset the module
        prev_a <= 0;
        rise_reg <= 0;
        down_reg <= 0;
    end else begin
        // Store the current state of 'a' in the previous state register
        prev_a <= a;
        
        // Check for rising edge
        if (a && !prev_a) begin
            rise_reg <= 1;
        end else begin
            rise_reg <= 0;
        end
        
        // Check for falling edge
        if (!a && prev_a) begin
            down_reg <= 1;
        end else begin
            down_reg <= 0;
        end
    end
end

// Assign output signals
assign rise = rise_reg;
assign down = down_reg;

endmodule