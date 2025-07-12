module edge_detect(
    input clk,      // Clock signal
    input rst_n,     // Reset signal (active low)
    input a,         // Input signal
    output rise,     // Output signal indicating a rising edge
    output down      // Output signal indicating a falling edge
);

reg prev_a;          // Flip-flop to store the previous state of 'a'
reg rise_reg;        // Register to store the 'rise' signal
reg down_reg;        // Register to store the 'down' signal

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin  // Reset
        prev_a <= 1'b0;
        rise_reg <= 1'b0;
        down_reg <= 1'b0;
    end else begin
        prev_a <= a;  // Store the current state of 'a' in the flip-flop
        if (a &&!prev_a) begin  // Check for rising edge
            rise_reg <= 1'b1;
        end else begin
            rise_reg <= 1'b0;
        end
        if (!a && prev_a) begin  // Check for falling edge
            down_reg <= 1'b1;
        end else begin
            down_reg <= 1'b0;
        end
    end
end

assign rise = rise_reg;  // Assign the 'rise' register to the output
assign down = down_reg;  // Assign the 'down' register to the output

endmodule