module ring_counter (
    input  wire       clk,
    input  wire       reset,
    output reg [7:0]  out
);

    always @(posedge clk) begin
        if (reset) begin
            out <= 8'b00000001;  // Initialize with LSB '1'
        end else begin
            if (out[7])
                out <= (out << 1) | 1;  // Wrap around when MSB is set
            else
                out <= out << 1;         // Shift left otherwise
        end
    end

endmodule