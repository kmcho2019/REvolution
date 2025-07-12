module edge_detect (
    input  clk,          // Clock signal
    input  rst_n,        // Reset signal (active low)
    input  a,           // Input signal to detect edges
    output rise,        // Output signal indicating a rising edge
    output down         // Output signal indicating a falling edge
);

reg t_ff_out;           // Output of the Toggle Flip-Flop
reg clk_enable;         // Clock enable signal

// Initialize the T-FF output to 0
initial begin
    t_ff_out = 1'b0;
end

// Clock enable logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin        // Reset condition
        clk_enable <= 1'b0;
    end else begin
        // Enable the clock when the input signal 'a' changes
        if (a !== t_ff_out) begin
            clk_enable <= 1'b1;
        end else begin
            clk_enable <= 1'b0;
        end
    end
end

// Toggle Flip-Flop
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin        // Reset condition
        t_ff_out <= 1'b0;
    end else if (clk_enable) begin
        // Toggle the output of the T-FF when the clock is enabled
        t_ff_out <= ~t_ff_out;
    end
end

// Assign the edge detection signals
assign rise = (t_ff_out == 1'b1) && (a == 1'b1);
assign down = (t_ff_out == 1'b0) && (a == 1'b0);

endmodule