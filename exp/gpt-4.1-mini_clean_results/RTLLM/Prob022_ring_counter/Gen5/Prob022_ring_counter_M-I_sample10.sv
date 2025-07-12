module ring_counter (
    input  wire       clk,
    input  wire       reset,
    output reg  [7:0] out
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            out <= 8'b00000001; // Initialize with LSB high
        end else begin
            // Rotate left by 1 with wrap-around: shift left, put MSB to LSB
            out <= {out[6:0], out[7]};
        end
    end

endmodule