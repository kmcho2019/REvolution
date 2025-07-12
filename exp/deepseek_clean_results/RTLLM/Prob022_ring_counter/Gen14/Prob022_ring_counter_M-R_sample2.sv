module ring_counter (
    input wire clk,
    input wire reset,
    output reg [7:0] out
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        out <= 8'b00000001;  // Initialize with LSB set
    end else begin
        // Shift left and wrap around
        if (out == 8'b10000000)
            out <= 8'b00000001;
        else
            out <= out << 1;
    end
end

endmodule