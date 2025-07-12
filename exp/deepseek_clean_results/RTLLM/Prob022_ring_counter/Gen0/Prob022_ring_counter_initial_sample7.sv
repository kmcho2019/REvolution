module ring_counter (
    input clk,
    input reset,
    output reg [7:0] out
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Initialize to 8'b0000_0001 on reset
        out <= 8'b0000_0001;
    end
    else begin
        // Rotate left by 1 bit with wrap-around
        out <= {out[6:0], out[7]};
    end
end

endmodule