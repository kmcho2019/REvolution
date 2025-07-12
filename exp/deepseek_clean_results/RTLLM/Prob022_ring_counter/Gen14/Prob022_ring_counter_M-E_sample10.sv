module ring_counter (
    input clk,
    input reset,
    output reg [7:0] out
);

always @(posedge clk) begin
    if (reset) begin
        out <= 8'b00000001;  // Initialize to LSB high
    end else begin
        // Circular left shift
        out <= {out[6:0], out[7]};
    end
end

endmodule