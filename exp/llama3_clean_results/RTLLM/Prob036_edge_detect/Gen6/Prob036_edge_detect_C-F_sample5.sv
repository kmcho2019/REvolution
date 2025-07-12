module edge_detect(
    input         clk,      // Clock signal
    input         rst_n,    // Reset signal (active low)
    input         a,        // Input signal
    output        rise,     // Output signal indicating a rising edge
    output        down      // Output signal indicating a falling edge
);

reg prev_a;  // Register to store the previous state of 'a'

// Initialize the previous state of 'a' and output signals to 0
initial begin
    prev_a = 1'b0;
    rise = 1'b0;
    down = 1'b0;
end

// Sequential logic to store the previous state of 'a'
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset the module
        prev_a <= 1'b0;
        rise <= 1'b0;
        down <= 1'b0;
    end else begin
        // Store the current state of 'a' in the previous state register
        prev_a <= a;
    end
end

// Combinational logic for edge detection using XOR gate
wire a_xor = a ^ prev_a;

// Set rise and down signals
always @(posedge clk) begin
    if (a_xor) begin
        if (a) begin
            rise <= 1'b1;
            down <= 1'b0;
        end else begin
            rise <= 1'b0;
            down <= 1'b1;
        end
    end else begin
        rise <= 1'b0;
        down <= 1'b0;
    end
end

endmodule