module ring_counter (
    input  wire       clk,
    input  wire       reset,
    output reg [7:0]  out
);

    always @(posedge clk) begin
        if (reset) begin
            out <= 8'b0000_0001; // Initialize with LSB = 1
        end else begin
            // Circular left rotate by 1 bit
            out <= {out[6:0], out[7]};
        end
    end

endmodule