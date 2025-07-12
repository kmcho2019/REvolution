module ring_counter (
    input clk,
    input reset,
    output reg [7:0] out
);

always @(posedge clk) begin
    if (reset) begin
        // Initialize to 00000001 when reset is high
        out <= 8'b0000_0001;
    end else begin
        // Shift left with wrap-around
        out <= {out[6:0], out[7]};
    end
end

endmodule