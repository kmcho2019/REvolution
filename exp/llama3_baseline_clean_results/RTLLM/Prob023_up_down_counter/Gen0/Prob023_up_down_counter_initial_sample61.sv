module up_down_counter(
    input clk,
    input reset,
    input up_down,
    output reg [15:0] count
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Reset counter to zero when reset signal is active
        count <= 16'd0;
    end else begin
        if (up_down) begin
            // Increment counter when up_down signal is high
            count <= count + 1;
        end else begin
            // Decrement counter when up_down signal is low
            count <= count - 1;
        end
    end
end

endmodule