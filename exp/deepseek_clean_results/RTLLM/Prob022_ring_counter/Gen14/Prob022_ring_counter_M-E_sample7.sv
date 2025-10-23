module ring_counter (
    input clk,
    input reset,
    output reg [7:0] out
);

always @(posedge clk) begin
    if (reset) begin
        out <= 8'b00000001;  // Initialize to first state
    end else begin
        // Shift left with wrap-around and self-correction
        out <= {out[6:0], out[7]};
        
        // Ensure exactly one bit is set (self-correcting)
        if (out == 8'b00000000) begin
            out <= 8'b00000001;
        end
    end
end

endmodule