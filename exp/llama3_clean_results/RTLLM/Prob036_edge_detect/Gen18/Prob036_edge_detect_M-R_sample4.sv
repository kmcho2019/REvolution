module edge_detect(
    input         clk,      // Clock signal
    input         rst_n,    // Reset signal (active low)
    input         a,        // Input signal
    output        rise,     // Output signal indicating a rising edge
    output        down      // Output signal indicating a falling edge
);

reg prev_a;  // Reg to store the previous state of 'a'

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset the previous state of 'a' and output signals
        prev_a <= 1'b0;
    end else begin
        // Store the current state of 'a' in the previous state reg
        prev_a <= a;
    end
end

assign rise = (a == 1'b1 && prev_a == 1'b0) ? 1'b1 : 1'b0;
assign down = (a == 1'b0 && prev_a == 1'b1) ? 1'b1 : 1'b0;

endmodule