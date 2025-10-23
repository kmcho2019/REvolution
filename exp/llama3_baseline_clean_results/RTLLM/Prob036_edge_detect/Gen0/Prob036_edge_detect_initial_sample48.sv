module edge_detect (
    input  clk,        // Clock signal
    input  rst_n,      // Reset signal (active low)
    input  a,          // Input signal
    output rise,       // Output signal indicating a rising edge
    output down        // Output signal indicating a falling edge
);

reg prev_a;            // Register to store the previous value of 'a'
reg rise_reg;          // Register to store the 'rise' output signal
reg down_reg;          // Register to store the 'down' output signal

// Detect rising and falling edges
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        prev_a <= 0;
        rise_reg <= 0;
        down_reg <= 0;
    end else begin
        prev_a <= a;
        if (a &&!prev_a) begin
            rise_reg <= 1;
        end else if (!a && prev_a) begin
            down_reg <= 1;
        end else begin
            rise_reg <= 0;
            down_reg <= 0;
        end
    end
end

// Assign output signals
assign rise = rise_reg;
assign down = down_reg;

endmodule