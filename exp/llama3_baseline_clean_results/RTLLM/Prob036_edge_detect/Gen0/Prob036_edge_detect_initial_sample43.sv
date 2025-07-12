module edge_detect(
    input clk,        // Clock signal
    input rst_n,      // Reset signal (active low)
    input a,          // Input signal
    output reg rise,  // Output signal indicating a rising edge
    output reg down   // Output signal indicating a falling edge
);

reg prev_a;           // Previous state of the input signal 'a'

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Initialize the state of the module on reset
        prev_a <= 0;
        rise <= 0;
        down <= 0;
    end else begin
        // Update the previous state of 'a'
        prev_a <= a;
        
        // Detect rising and falling edges
        if (a && !prev_a) begin
            rise <= 1;
            down <= 0;
        end else if (!a && prev_a) begin
            rise <= 0;
            down <= 1;
        end else begin
            rise <= 0;
            down <= 0;
        end
    end
end

endmodule