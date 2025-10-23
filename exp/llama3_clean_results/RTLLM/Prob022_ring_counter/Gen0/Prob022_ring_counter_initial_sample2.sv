module ring_counter(
    input   clk,          // Clock signal
    input   reset,        // Reset signal
    output reg [7:0] out  // 8-bit output
);

always @ (posedge clk or posedge reset) begin
    if (reset) begin
        out <= 8'b0000_0001;  // Reset to the initial state
    end else begin
        // Shift the 1 bit to the next position, wrapping around if necessary
        out <= {out[6:0], out[7]};  
    end
end

endmodule