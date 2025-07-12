module ring_counter (
    input clk,
    input reset,
    output reg [7:0] out
);

always @(posedge clk) begin
    if (reset) begin
        out <= 8'b00000001;  // Initialize to LSB set
    end
    else begin
        // Explicit circular shift
        if (out[7]) begin
            out <= 8'b00000001;  // Wrap around to LSB
        end
        else begin
            out <= out << 1;     // Normal left shift
        end
    end
end

endmodule