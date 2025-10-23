module ring_counter (
    input clk,
    input reset,
    output reg [7:0] out
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        out <= 8'b00000001;  // Reset to initial state (LSB set)
    end
    else begin
        // Rotate right operation - shift with wrap-around
        out <= {out[0], out[7:1]};
    end
end

endmodule