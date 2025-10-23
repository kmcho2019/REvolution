module ring_counter (
    input clk,
    input reset,
    output reg [7:0] out
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        out <= 8'b00000001;  // Initialize to LSB high
    end else begin
        // Shift left with wrap-around
        out <= (out == 8'b10000000) ? 8'b00000001 : (out << 1);
    end
end

endmodule