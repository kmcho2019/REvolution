module edge_detect (
    input clk,
    input rst_n,
    input a,
    output rise,
    output down
);

reg prev_a; // Register to store the previous state of signal 'a'
reg rise_reg; // Register to store the rise output signal
reg down_reg; // Register to store the down output signal

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        prev_a <= 0; // Reset previous state to 0
        rise_reg <= 0; // Reset rise output signal to 0
        down_reg <= 0; // Reset down output signal to 0
    end else begin
        prev_a <= a; // Update previous state with current state
        if (a && !prev_a) begin // Check for rising edge
            rise_reg <= 1; // Set rise output signal to 1
            down_reg <= 0; // Reset down output signal to 0
        end else if (!a && prev_a) begin // Check for falling edge
            rise_reg <= 0; // Reset rise output signal to 0
            down_reg <= 1; // Set down output signal to 1
        end else begin
            rise_reg <= 0; // Reset rise output signal to 0
            down_reg <= 0; // Reset down output signal to 0
        end
    end
end

assign rise = rise_reg; // Assign rise output signal
assign down = down_reg; // Assign down output signal

endmodule