module ring_counter (
    input clk,
    input reset,
    output reg [7:0] out
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Initialize with LSB set to 1
        out <= 8'b00000001;
    end
    else begin
        // Circular shift left using concatenation
        out <= {out[6:0], out[7]};
    end
end

endmodule