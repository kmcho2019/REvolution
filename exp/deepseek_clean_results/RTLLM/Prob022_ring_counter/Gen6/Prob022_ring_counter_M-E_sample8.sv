module ring_counter (
    input clk,
    input reset,
    output reg [7:0] out
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        out <= 8'b00000001;  // Initialize with LSB set
    end
    else begin
        // Shift left normally, but when MSB is set, wrap around to LSB
        out <= out[6:0] ? {out[6:0], 1'b0} : 8'b00000001;
    end
end

endmodule