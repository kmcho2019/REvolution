module edge_detect (
    input  clk,          // Clock signal
    input  rst_n,        // Reset signal (active low)
    input  a,           // Input signal to detect edges
    output rise,        // Output signal indicating a rising edge
    output down         // Output signal indicating a falling edge
);

reg prev_a;            // Register to hold the previous state of 'a'
reg rise_reg;          // Register for the rise output
reg down_reg;          // Register for the down output

// Initialize the output registers to 0
initial begin
    rise_reg = 1'b0;
    down_reg = 1'b0;
    prev_a = 1'b0;
end

// Main logic for edge detection
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin        // Reset condition
        rise_reg <= 1'b0;
        down_reg <= 1'b0;
        prev_a <= 1'b0;
    end else begin
        // Store the current state of 'a' for the next clock cycle
        prev_a <= a;
        
        // Detect rising edge (a transitions from 0 to 1)
        if ((prev_a == 1'b0) && (a == 1'b1)) begin
            rise_reg <= 1'b1;
        end else begin
            rise_reg <= 1'b0;
        end
        
        // Detect falling edge (a transitions from 1 to 0)
        if ((prev_a == 1'b1) && (a == 1'b0)) begin
            down_reg <= 1'b1;
        end else begin
            down_reg <= 1'b0;
        end
    end
end

// Assign the registered outputs to the output ports
assign rise = rise_reg;
assign down = down_reg;

endmodule