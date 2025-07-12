module edge_detect (
    input  clk,    // Clock signal
    input  rst_n,  // Reset signal (active low)
    input  a,      // Input signal
    output rise,   // Output signal indicating a rising edge
    output down    // Output signal indicating a falling edge
);

reg prev_a;  // Register to store the previous state of 'a'
reg rise_reg;  // Register to store the output 'rise'
reg down_reg;  // Register to store the output 'down'

// Initialize 'rise' and 'down' to 0 at reset
initial begin
    rise_reg = 0;
    down_reg = 0;
end

// Store the previous state of 'a' on every positive edge of 'clk'
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        prev_a <= 0;
        rise_reg <= 0;
        down_reg <= 0;
    end else begin
        prev_a <= a;
        
        // Detect rising and falling edges
        if (a && !prev_a) begin
            rise_reg <= 1;
            down_reg <= 0;
        end else if (!a && prev_a) begin
            rise_reg <= 0;
            down_reg <= 1;
        end else begin
            rise_reg <= 0;
            down_reg <= 0;
        end
    end
end

// Assign the registered outputs to the output ports
assign rise = rise_reg;
assign down = down_reg;

endmodule