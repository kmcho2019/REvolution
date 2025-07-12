module ring_counter (
    input  wire       clk,
    input  wire       reset,
    output reg  [7:0] out
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            out <= 8'b0000_0001;   // Initialize with LSB set
        end else begin
            // Shift left with wrap-around of MSB to LSB
            out <= {out[6:0], out[7]};
        end
    end

endmodule