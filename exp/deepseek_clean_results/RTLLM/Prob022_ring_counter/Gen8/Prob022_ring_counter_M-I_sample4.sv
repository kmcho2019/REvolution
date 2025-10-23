module ring_counter (
    input clk,
    input reset,
    output reg [7:0] out
);

always @(posedge clk) begin
    if (reset) begin
        out <= 8'b0000_0001;  // Initialize to LSB set
    end
    else begin
        out <= {out[6:0], out[7]};  // Rotate left with wrap-around
    end
end

endmodule