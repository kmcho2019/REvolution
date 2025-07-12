module up_down_counter(
    input clk,
    input reset,
    input up_down,
    output reg [15:0] count
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        count <= 16'd0; // Reset counter to zero
    end else begin
        if (up_down) begin
            count <= count + 1; // Increment counter
        end else begin
            count <= count - 1; // Decrement counter
        end
    end
end

endmodule