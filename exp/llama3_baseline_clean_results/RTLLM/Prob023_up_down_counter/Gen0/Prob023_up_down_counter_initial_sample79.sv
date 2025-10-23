module up_down_counter(
    input clk,
    input reset,
    input up_down,
    output reg [15:0] count
);

always @(posedge clk) begin
    if (reset) begin
        // Reset the counter to zero when reset is active
        count <= 16'd0;
    end else begin
        // Check the up_down control signal to decide whether to increment or decrement
        if (up_down) begin
            // Increment the counter
            count <= count + 1;
        end else begin
            // Decrement the counter, ensuring it doesn't go below zero
            count <= (count == 0) ? 0 : count - 1;
        end
    end
end

endmodule