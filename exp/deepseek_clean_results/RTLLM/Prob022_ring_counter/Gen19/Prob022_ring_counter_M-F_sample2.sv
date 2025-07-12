module ring_counter (
    input clk,
    input reset,
    output reg [7:0] out
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        out <= 8'b00000001;  // Initialize with LSB set
    end else begin
        // Shift left with wrap-around using bit-wise assignment
        out <= {out[6:0], 1'b0};  // Shift left
        out[0] <= out[7];         // Wrap-around the MSB to LSB
    end
end

endmodule