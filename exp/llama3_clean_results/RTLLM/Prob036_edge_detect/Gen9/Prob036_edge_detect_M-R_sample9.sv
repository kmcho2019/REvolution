module edge_detect(
    input         clk,      // Clock signal
    input         rst_n,    // Reset signal (active low)
    input         a,        // Input signal
    output        rise,     // Output signal indicating a rising edge
    output        down      // Output signal indicating a falling edge
);

reg prev_a;  // Register to store the previous state of 'a'
reg rise_reg;  // Register to store the rise signal
reg down_reg;  // Register to store the down signal

// Sequential logic to store the previous state of 'a' and detect edges
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset the module
        prev_a <= 1'b0;
        rise_reg <= 1'b0;
        down_reg <= 1'b0;
    end else begin
        // Store the current state of 'a' in the previous state register
        prev_a <= a;
        
        // Detect rising and falling edges
        if (a == 1'b1 && prev_a == 1'b0) begin
            rise_reg <= 1'b1;
            down_reg <= 1'b0;
        end else if (a == 1'b0 && prev_a == 1'b1) begin
            rise_reg <= 1'b0;
            down_reg <= 1'b1;
        end else begin
            rise_reg <= 1'b0;
            down_reg <= 1'b0;
        end
    end
end

// Assign output signals
assign rise = rise_reg;
assign down = down_reg;

endmodule