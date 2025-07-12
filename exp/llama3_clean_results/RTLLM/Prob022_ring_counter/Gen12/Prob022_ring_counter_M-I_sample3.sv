module ring_counter(
    input  wire clk,
    input  wire reset,
    output reg  [7:0] out
);

reg [2:0] pos;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        pos <= 3'd0;
        out <= 8'b0000_0001;
    end else begin
        pos <= (pos + 1) % 8;
        out <= 8'b0; // Initialize out to all zeros
        out[pos] <= 1'b1; // Set the bit at position pos to 1
    end
end

endmodule