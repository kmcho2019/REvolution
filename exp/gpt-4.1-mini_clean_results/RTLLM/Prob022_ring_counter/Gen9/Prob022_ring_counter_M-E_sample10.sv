module ring_counter (
    input  wire       clk,
    input  wire       reset,
    output reg [7:0]  out
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            out <= 8'b00000001; // initialize LSB on reset
        end else begin
            // Circular left shift by 1:
            // Move MSB to LSB and shift rest left by 1
            out <= {out[6:0], out[7]};
        end
    end

endmodule