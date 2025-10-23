module ring_counter(
    input clk,
    input reset,
    output reg [7:0] out
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        out <= 1; // Initialize with the LSB set to  end else begin
        out <= (out >> 1) | (out[] << ); // Shift right and wrap around
    end
end

endmodule