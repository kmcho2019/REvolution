module ring_counter(
    input clk,
    input reset,
    output reg [7:0] out
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        out <= 8'b0000_0001; // Reset to the initial state
    end else begin
        out <= (out == 8'b1000_0000) ? 8'b0000_0001 : (out << 1); // Update the current state
    end
end

endmodule