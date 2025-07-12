module up_down_counter(
    input clk,
    input reset,
    input up_down,
    output reg [15:0] count
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Reset the counter to zero when reset is active
        count <= 16'd0;
    end else begin
        // Determine the counting direction based on up_down signal
        if (up_down) begin
            // Increment the counter if up_down is high
            count <= count + 1;
        end else begin
            // Decrement the counter if up_down is low
            count <= count - 1;
        end
    end
end

endmodule