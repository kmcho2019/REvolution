module ring_counter(
    input clk,
    input reset,
    output reg [7:0] out
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        out <= 8'b0000_0001; // Reset to initial state
    end else begin
        // Cyclic shift: find the position of the '1' and shift it
        for (int i = 0; i < 8; i++) begin
            if (out[i]) begin
                out <= 1 << ((i + 1) % 8); // Shift '1' to the next position, wrapping around if necessary
                break;
            end
        end
    end
end

endmodule