module ring_counter (
    input wire clk,
    input wire reset,
    output reg [7:0] out
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        out <= 8'b0000_0001;
    end else begin
        // Rotate left: shift left by 1, wrap the MSB back to LSB
        out <= {out[6:0], out[7]};
    end
end

endmodule