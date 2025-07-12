module up_down_counter(
    input clk,
    input reset,
    input up_down,
    output reg [15:0] count
);

always @ (posedge clk) begin
    if (reset) begin
        // Reset the counter to zero
        count <= 16'd0;
    end else begin
        // Determine the counting direction based on the up_down signal
        if (up_down) begin
            // Increment the counter
            count <= count + 16'd1;
        end else begin
            // Decrement the counter, but avoid underflow
            count <= (count == 16'd0) ? 16'd0 : count - 16'd1;
        end
    end
end

endmodule