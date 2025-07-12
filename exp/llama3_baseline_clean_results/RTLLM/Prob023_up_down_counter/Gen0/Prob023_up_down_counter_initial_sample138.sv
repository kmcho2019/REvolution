module up_down_counter(
    input clk,
    input reset,
    input up_down,
    output reg [15:0] count
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        count <= 16'd0; // Reset the counter to zero when reset is high
    end else begin
        if (up_down) begin
            count <= count + 1; // Increment the counter when up_down is high
        end else begin
            count <= count - 1; // Decrement the counter when up_down is low
        end
    end
end

endmodule