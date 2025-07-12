module ring_counter (
    input  wire       clk,
    input  wire       reset,
    output reg  [7:0] out
);

    always @(posedge clk) begin
        if (reset) begin
            out <= 8'b0000_0001;   // Initialize with LSB set
        end else begin
            // Rotate right by 1: bit0 becomes bit7, and others shift right by 1
            out <= {out[0], out[7:1]};
        end
    end

endmodule