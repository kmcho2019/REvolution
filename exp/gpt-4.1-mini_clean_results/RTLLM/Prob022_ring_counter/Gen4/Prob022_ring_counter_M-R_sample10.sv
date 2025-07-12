module ring_counter (
    input  wire       clk,
    input  wire       reset,
    output reg [7:0]  out
);

    always @(posedge clk) begin
        if (reset) begin
            out <= 8'b00000001;  // Initialize with LSB '1'
        end else begin
            if (out[7]) begin
                out <= 8'b00000001;  // Wrap around to LSB
            end else begin
                out <= out << 1;     // Shift left by 1
            end
        end
    end

endmodule