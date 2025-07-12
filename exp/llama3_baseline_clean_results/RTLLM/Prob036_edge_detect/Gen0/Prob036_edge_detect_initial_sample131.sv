module edge_detect (
    input clk,
    input rst_n,
    input a,
    output rise,
    output down
);

reg prev_a;  // Register to store the previous state of 'a'
reg rise_reg;  // Register to store the 'rise' signal
reg down_reg;  // Register to store the 'down' signal

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        prev_a <= 0;  // Initialize 'prev_a' to 0 on reset
        rise_reg <= 0;  // Initialize 'rise_reg' to 0 on reset
        down_reg <= 0;  // Initialize 'down_reg' to 0 on reset
    end else begin
        prev_a <= a;  // Store the current state of 'a' in 'prev_a'
        if (a && !prev_a) begin
            rise_reg <= 1;  // Set 'rise_reg' to 1 on rising edge
            down_reg <= 0;  // Set 'down_reg' to 0
        end else if (!a && prev_a) begin
            down_reg <= 1;  // Set 'down_reg' to 1 on falling edge
            rise_reg <= 0;  // Set 'rise_reg' to 0
        end else begin
            rise_reg <= 0;  // Set 'rise_reg' to 0 if no rising edge
            down_reg <= 0;  // Set 'down_reg' to 0 if no falling edge
        end
    end
end

assign rise = rise_reg;  // Assign 'rise_reg' to output 'rise'
assign down = down_reg;  // Assign 'down_reg' to output 'down'

endmodule