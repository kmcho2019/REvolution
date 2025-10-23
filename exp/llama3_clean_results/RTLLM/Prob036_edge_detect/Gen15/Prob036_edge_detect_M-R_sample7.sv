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

// Combinational logic to detect rising and falling edges
assign rise = (a && !prev_a);
assign down = (!a && prev_a);

endmodule