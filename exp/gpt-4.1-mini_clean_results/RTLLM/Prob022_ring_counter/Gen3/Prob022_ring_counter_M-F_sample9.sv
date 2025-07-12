module ring_counter (
    input  wire       clk,
    input  wire       reset,
    output reg [7:0]  out
);

    always @(posedge clk) begin
        if (reset) begin
            out <= 8'b00000001;  // Initialize with LSB '1'
        end else begin
            out <= {out[6:0], out[7]};  // Rotate left with wrap-around
        end
    end

endmodule