module ring_counter(
    input clk,
    input reset,
    output reg [7:0] out
);

reg [2:0] count; // 3-bit counter to keep track of current position

always @(posedge clk or posedge reset) begin
    if (reset) begin
        count <= 3'b000; // Reset counter to 0 when reset is high
    end else begin
        count <= (count + 1) % 8; // Increment counter modulo 8 on each clock edge
    end
end

// Use continuous assignment to generate output based on count
assign out = (1 << count); // Shift '1' to the position indicated by count

endmodule