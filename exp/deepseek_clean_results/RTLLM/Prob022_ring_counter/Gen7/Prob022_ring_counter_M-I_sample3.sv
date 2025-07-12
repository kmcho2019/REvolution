module ring_counter (
    input clk,
    input reset,
    output reg [7:0] out
);

reg msb_temp;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        out <= 8'b00000001;  // Initialize with LSB set
    end
    else begin
        msb_temp = out[7];   // Store MSB before shifting
        out[7:1] <= out[6:0]; // Shift left
        out[0] <= msb_temp;  // Wrap-around
    end
end

endmodule