module up_down_counter(
    input clk,
    input reset,
    input up_down,
    output reg [15:0] count
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        count <= 16'd0;  // Reset count to 0
    end else begin
        if (up_down) begin
            count <= count + 1;  // Increment count
        end else begin
            count <= count - 1;  // Decrement count
        end
    end
end

endmodule