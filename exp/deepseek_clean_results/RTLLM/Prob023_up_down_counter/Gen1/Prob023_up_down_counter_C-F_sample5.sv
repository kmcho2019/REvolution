module up_down_counter (
    input clk,
    input reset,
    input up_down,
    output reg [15:0] count
);

always @(posedge clk) begin
    if (reset) begin
        count <= 16'b0;          // Synchronous reset
    end else if (up_down) begin
        count <= count + 1'b1;   // Increment with explicit 1-bit notation
    end else begin
        count <= count - 1'b1;   // Decrement with explicit 1-bit notation
    end
end

endmodule