module up_down_counter(
    input clk,
    input reset,
    input up_down,
    output reg [15:0] count
);

always @(posedge clk) begin
    if (reset) begin
        // Reset the counter to zero when reset is high
        count <= 16'd0;
    end else begin
        // Check the up_down signal to decide the counting direction
        if (up_down) begin
            // Increment the counter when up_down is high
            count <= count + 1;
        end else begin
            // Decrement the counter when up_down is low
            count <= count - 1;
        end
    end
end

endmodule