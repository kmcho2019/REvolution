module up_down_counter (
    input clk,
    input reset,
    input up_down,
    output reg [15:0] count
);

always @(posedge clk) begin
    if (reset) begin
        count <= 16'b0;  // Synchronous reset to zero
    end
    else begin
        if (up_down) begin
            count <= count + 1;  // Increment when up_down is high
        end
        else begin
            count <= count - 1;  // Decrement when up_down is low
        end
    end
end

endmodule