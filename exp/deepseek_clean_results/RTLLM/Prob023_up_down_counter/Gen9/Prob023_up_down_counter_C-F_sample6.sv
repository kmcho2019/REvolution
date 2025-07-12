module up_down_counter (
    input clk,
    input reset,
    input up_down,
    output reg [15:0] count
);

always @(posedge clk) begin
    if (reset) begin
        count <= 16'h0000;
    end else begin
        if (up_down) begin
            // Increment with automatic carry propagation
            count <= count + 1'b1;
        end else begin
            // Decrement with automatic borrow propagation
            count <= count - 1'b1;
        end
    end
end

endmodule