module ring_counter (
    input clk,
    input reset,
    output reg [7:0] out
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Initialize with LSB set
        out <= 8'b00000001;
    end
    else begin
        // Shift left with wrap-around
        if (out == 8'b10000000) begin
            out <= 8'b00000001;  // Wrap around from MSB to LSB
        end
        else begin
            out <= out << 1;      // Normal shift left
        end
    end
end

endmodule