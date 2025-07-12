module ring_counter (
    input clk,
    input reset,
    output reg [7:0] out
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        out <= 8'b0000_0001;      // Initialize on reset
    end else begin
        // Shift left with wrap-around
        out <= (out == 8'b1000_0000) ? 8'b0000_0001 : out << 1;
    end
end

endmodule